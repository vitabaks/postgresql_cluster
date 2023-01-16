#!/bin/bash

# Copyright © 2022 Ilgiz Mamyshev https://github.com/IlgizMamyshev
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.

readonly productname="DNS Connection Point for Patroni";
readonly giturl="https://github.com/IlgizMamyshev/dnscp";
readonly version="17012023";

### Script for Patroni clusters
# Script Features:
# * Add VIP address to network interface if Patroni start Leader role
# * Remove VIP address from network interface if Patroni stop or switch to non-Leader role
# * Register\Update DNS A-record for PostgreSQL client access

### Installing script
# * Enable using callbacks in Patroni configuration (/etc/patroni/patroni.yml):
#postgresql:
#  callbacks:
#    on_start: /etc/patroni/dnscp.sh -vips '<VIPs>' -pwdfile '/etc/patroni/dnscp.secret' -dnszonefqdn '<DNSzoneFQDN>' -dnsserver '<DNSserver>' -ttl '<TTL>' -- on_schedule registerdns <VCompName>
#    on_stop: /etc/patroni/dnscp.sh ..
#    on_role_change: /etc/patroni/dnscp.sh ..
# * Put script to "/etc/patroni/dnscp.sh" and set executable (adds the execute permission for all users to the existing permissions.):
#   sudo mv dnscp.sh /etc/patroni/dnscp.sh && sudo chmod ugo+x /etc/patroni/dnscp.sh
# * View command for dnsupdate:
#   sudo cat /var/spool/cron/crontabs/postgres

### Operation System prerequisites
# * Astra Linux (Debian or compatible)

### PostgreSQL prerequisites
# For any virtual IP based solutions to work in general with Postgres you need to make sure that it is configured to automatically scan and bind to all found network interfaces. So something like * or 0.0.0.0 (IPv4 only) is needed for the listen_addresses parameter to activate the automatic binding. This again might not be suitable for all use cases where security is paramount for example.
## nonlocal bind
# If you can't set listen_addresses to a wildcard address, you can explicitly specify only those adresses that you want to listen to. However, if you add the virtual IP to those addresses, PostgreSQL will fail to start when that address is not yet registered on one of the interfaces of the machine. You need to configure the kernel to allow "nonlocal bind" of IP (v4) addresses:
# * temporarily:
# sysctl -w net.ipv4.ip_nonlocal_bind=1
# * permanently:
# echo "net.ipv4.ip_nonlocal_bind = 1"  >> /etc/sysctl.conf
# sysctl -p

### DNS Name as Client Access Point prerequisites
# Scenario 1 (AD DNS ans secure DNS update):
#   * Patroni hosts must be joined to Active Directory Domain
#       For expample: Join Astra Linux to Active Directory https://wiki.astralinux.ru/pages/viewpage.action?pageId=27361515
#           sudo apt-get install astra-winbind && sudo astra-winbind -dc dc1.example.ru -u Administrator -px
#   * Create Active Directory Computer Account (will be used as network name for client access) in any way, for example (PowerShell, from domain joined Windows Server): New-ADComputer pgsql
#   * Set new password for Computer Account, for example (PowerShell): Get-ADComputer pgsql | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd" -Force)
# Scenario 2 (Non-secure DNS update):
#   * Microsoft DNS Server and DNS-zone with allow non-secure DNS update.
# Common:
#   * Install nsupdate utility: sudo apt-get install dnsutils

#####################################################
# Set variable defaults
#####################################################
VIPs="";                                            #
VCompPasswordFile="dnscp.secret"                    # file with clear text password in current path
VCompPassword=`cat $VCompPasswordFile 2>/dev/null`; # empty for non-secure DNS update
DNSzoneFQDN="";                                     # empty for automatically detect
DNSserver="";                                       # empty for automatically detect
TTL=1200;                                           # TTL=1200 - default. Use for example TTL=30 for multi-site clusters.

#####################################################
# Funtions
#####################################################
function usage() {
echo "Usage:";
echo "  $0 [OPTION...] -- <on_start|on_stop|on_role_change> <role> <scope>";
echo "";
echo "$productname, version $version, $giturl";
echo "";
echo "Help Options:";
echo "  -h, --help                Show help options.";
echo "";
echo "Script Options:";
echo "  -d";
echo "      Debug mode.";
echo "  -dnszonefqdn {zonename}";
echo "      Specify DNS zone full qualified domain name. The default is '' (empty), for automatically detect (recommended).";  
echo "  -dnsserver {servername}";
echo "      Specify nework name or IP or '' (empty). The default is '' (empty), for automatically detect (recommended).";
echo "      Used for register DNS name.";
echo "  -ttl {seconds}";
echo "      Specify the time to live for DNS record to be added. The default is 1200.";
echo "      Specify the TTL=30 for multi-site clusters (recommended).";
echo "  -pwdfile {passwordfile}";
echo "      Path to the file with password for Virtual Computer Name account in Active Directory\SAMBA.";
echo "      Virtual Computer Name = Patroni Cluster Name. The default is '' (empty). Do not specify for non-secure DNS update.";
echo "  -v";
echo "      Verbose mode.";
echo "  -vips {address[,address..]}";
echo "      One VIP (IPv4) address (or some VIP addresses in different subnets, separated by commas, for example: '10.0.1.10,10.0.2.10').";
echo "  -V, -version";
echo "      Print the version number and exit.";
exit 1; }

function in_subnet {
    # Determine whether IP address is in the specified subnet.
    #
    # Args:
    #   sub: Subnet, in CIDR notation.
    #   ip: IP address to check.
    #
    # Returns:
    #   1|0
    #
    local ip ip_a mask netmask sub sub_ip rval start end

    # Define bitmask.
    local readonly BITMASK=0xFFFFFFFF

    # Set DEBUG status if not already defined in the script.
    [[ "${DEBUG}" == "" ]] && DEBUG=0

    # Read arguments.
    IFS=/ read sub mask <<< "${1}"
    IFS=. read -a sub_ip <<< "${sub}"
    IFS=. read -a ip_a <<< "${2}"

    # Calculate netmask.
    netmask=$(($BITMASK<<$((32-$mask)) & $BITMASK))

    # Determine address range.
    start=0
    for o in "${sub_ip[@]}"
    do
        start=$(($start<<8 | $o))
    done

    start=$(($start & $netmask))
    end=$(($start | ~$netmask & $BITMASK))

    # Convert IP address to 32-bit number.
    ip=0
    for o in "${ip_a[@]}"
    do
        ip=$(($ip<<8 | $o))
    done

    # Determine if IP in range.
    (( $ip >= $start )) && (( $ip <= $end )) && rval=1 || rval=0

    (( $DEBUG )) &&
        printf "ip=0x%08X; start=0x%08X; end=0x%08X; in_subnet=%u\n" $ip $start $end $rval 1>&2
    echo "${rval}"
}

#####################################################
# Set variables
#####################################################
readonly LOGHEADER="Patroni Callback"
MSG="[$LOGHEADER] Called: $0 $*"

# Options processing
while [ -n "$1" ]
do
case "$1" in
-h | --help) usage; ;;
-d) DEBUG=1
shift ;;
-v) VERBOSE=1
shift ;;
-V | --version) echo "$version"; exit 0; ;;
-vips) VIPs="$2"
shift ;;
-pwdfile) if [[ "" == "$2" ]]; then
    VCompPassword=""; VCompPasswordFile="";
  else
    VCompPassword=`cat $2`; VCompPasswordFile=$2;
  fi
shift ;;
-dnszonefqdn) DNSzoneFQDN="$2"
shift ;;
-dnsserver) DNSserver="$2"
shift ;;
-ttl) TTL="$2"
shift ;;
--) shift
break ;;
*) echo "$1 is not an option"; usage; ;;
esac
shift
done

# Parameters processing
readonly SCRIPTNAME=$(echo $0 | awk -F"/" '{print $NF}')
readonly SCRIPTPATH=$(dirname $0)
readonly CB_NAME=$1
readonly ROLE=$2
readonly VCompName=$3

[[ "${VERBOSE}" == "" ]] && VERBOSE=0
[[ "${DEBUG}" == "" ]] && DEBUG=0

if [[ $VERBOSE -eq 1 ]]; then echo $MSG; fi
if [[ $DEBUG -eq 1 ]]; then
    echo "VIPs=$VIPs";
    echo "VCompName=$VCompName";
    echo "VCompPassword=$VCompPassword";
    echo "VCompPasswordFile=$VCompPasswordFile";
    echo "DNSzoneFQDN=$DNSzoneFQDN";
    echo "DNSserver=$DNSserver";
    echo "TTL=$TTL";
fi

#####################################################
# Check prerequisites
#####################################################
## VIPs defined?
if [[ "" == "$VIPs" ]]; then
    echo "[$LOGHEADER] INFO: Check prerequisites: VIPs not defined. Nothing to do.";
    exit 0; # Exit without error
fi

## Active Directory\SAMBA Domain joined?
JOINED_OK=""
if [[ ! -z $VCompPassword ]]; then
    JOINED_OK=$(sudo net ads testjoin | awk '{print $NF}')
    if [[ "OK" == "$JOINED_OK" ]]; then
        # Detect DNS zone FQDN
        if [[ "" == "$DNSzoneFQDN" ]]; then
            DNSzoneFQDN=$(sudo net ads info | awk -F": " '{if ($1 == "Realm") print tolower($2)}')
            if [[ $VERBOSE -eq 1 ]]; then echo "[$LOGHEADER] INFO: Detected DNS zone FQDN is $DNSzoneFQDN"; fi
        fi
    else
        echo "[$LOGHEADER] WARNING: Check prerequisites: Not joined to Active Directory\SAMBA Domain!";
    fi
    # $VCompPassword is empty. Script configured for non-secure DNS update.
fi

## package is installed?
REQUIRED_PKG="dnsutils"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
if [[ "" == "$PKG_OK" ]]; then
    echo "[$LOGHEADER] WARNING: Check prerequisites: No $REQUIRED_PKG.";
    #sudo apt-get --yes install $REQUIRED_PKG #Setting up $REQUIRED_PKG
    exit 1; # Exit with error
else
    # Detect DNS Server
    if [[ "" == "$DNSserver" ]] && [[ "OK" == "$JOINED_OK" ]]; then
        DNSserver=$(sudo net ads info | awk -F": " '{if ($1 == "LDAP server name") print $2}') # AD DS logon DC
        if [[ $VERBOSE -eq 1 ]]; then echo "[$LOGHEADER] INFO: Detected DNS Server is $DNSserver"; fi
    fi
fi

# Set failsafe value
if [[ "" == "$DNSserver" ]] && [[ "" != "$DNSzoneFQDN" ]]; then
    DNSserver=$DNSzoneFQDN
fi

# Last check
if [[ "" == "$DNSzoneFQDN" ]] || [[ "" == "$DNSserver" ]] || [[ "" == "$VCompName" ]]; then
    MSG=""; MSGSEPARATOR="";
    if [[ "" == "$DNSzoneFQDN" ]]; then MSG="$MSG${MSGSEPARATOR}DNSzoneFQDN"; MSGSEPARATOR=", "; fi
    if [[ "" == "$DNSserver" ]]; then MSG="$MSG${MSGSEPARATOR}DNSserver"; MSGSEPARATOR=", "; fi
    if [[ "" == "$VCompName" ]]; then MSG="$MSG${MSGSEPARATOR}$MSGVCompName"; MSGSEPARATOR=", "; fi
    echo "[$LOGHEADER] INFO: DNSCP does not know about $MSG. Only VIPs wil be managed.";
fi

readonly VCompNameFQDN=$VCompName.$DNSzoneFQDN

#####################################################
# Main
#####################################################
# Network interface name
IFNAME=$(ip --oneline addr show | awk '$3 == "inet" && $2 != "lo" { print $2; exit}') # or "eth0"

# Network id
NETWORK=$(ip --oneline addr show | awk '$3 == "inet" && $2 != "lo" { print $4; exit}') # 123.123.123.123/24
NETID=$(echo $NETWORK | awk -F"/" '{print $2}')

# Check witch IP is in network range
for IP in $(echo $VIPs | awk '{gsub(","," "); print $0}'); do
    (( $(in_subnet "$NETWORK" "$IP") )) && VIP=$IP
done

if [[ -z $VIP ]]; then
    echo "[$LOGHEADER] WARNING: No suitable VIP ($VIPs) for $NETWORK";
else
    #####################################################
    # VIP
    #####################################################
    if [[ $DEBUG -eq 1 ]]; then echo "[$LOGHEADER] INFO: VIP $VIP is candidate for current network"; fi
    case $CB_NAME in
        on_stop )
            #####################################################
            # Remove service_ip if exists
            #####################################################
            if [[ ! -z $(ip address | awk '/'$VIP'/{print $0}') ]]; then
                sudo ip address del $VIP/$NETID dev $IFNAME;
                EXITCODE=$?;
                if [[ $EXITCODE -eq 0 ]]; then
                    echo "[$LOGHEADER] INFO: Deleting VIP '$VIP/$NETID dev $IFNAME' by Patroni $CB_NAME callback SUCCEEDED";
                else
                    echo "[$LOGHEADER] ERROR: Deleting VIP '$VIP/$NETID dev $IFNAME' by Patroni $CB_NAME callback is FAILED with error code $EXITCODE.";
                fi

                # Remove cron task
                sudo crontab -u $(whoami) -l | grep -v "$0" | sudo crontab -u $(whoami) -
            else
                if [[ $VERBOSE -eq 1 ]]; then echo "[$LOGHEADER] INFO: VIP $VIP not exist, no action required."; fi
            fi
            ;;
        on_start|on_role_change|on_schedule )
            if [[ $ROLE == 'master' ]]; then
                #####################################################
                # Add service_ip if not exists
                #####################################################
                if [[ -z $(ip address | awk '/'$VIP'/{print $0}') ]]; then
                    sudo ip address add $VIP/$NETID dev $IFNAME;
                    EXITCODE=$?;
                    if [[ $EXITCODE -eq 0 ]]; then
                        echo "[$LOGHEADER] INFO: Adding VIP '$VIP/$NETID dev $IFNAME' by Patroni $CB_NAME callback SUCCEEDED";
                    else
                        echo "[$LOGHEADER] ERROR: Adding VIP '$VIP/$NETID dev $IFNAME' by Patroni $CB_NAME callback is FAILED with error code $EXITCODE.";
                    fi
                else
                    if [[ $VERBOSE -eq 1 ]]; then echo "[$LOGHEADER] INFO: VIP $VIP already present, no action required."; fi
                fi
            fi

            if [[ $ROLE == 'replica' ]]; then
                #####################################################
                # Remove service_ip if exists
                #####################################################
                if [[ ! -z $(ip address | awk '/'$VIP'/{print $0}') ]]; then
                    sudo ip address del $VIP/$NETID dev $IFNAME;
                    EXITCODE=$?;
                    if [[ $EXITCODE -eq 0 ]]; then
                        echo "[$LOGHEADER] INFO: Deleting VIP '$VIP/$NETID dev $IFNAME' by Patroni $CB_NAME callback SUCCEEDED";
                    else
                        echo "[$LOGHEADER] ERROR: Deleting VIP '$VIP/$NETID dev $IFNAME' by Patroni $CB_NAME callback is FAILED with error code $EXITCODE.";
                    fi

                    # Remove cron task
                    sudo crontab -u $(whoami) -l | grep -v "$0" | sudo crontab -u $(whoami) -
                else
                    if [[ $VERBOSE -eq 1 ]]; then echo "[$LOGHEADER] INFO: VIP $VIP not exist, no action required."; fi
                fi
            fi

            if [[ $ROLE == 'master' ]] || ( [[ $ROLE == 'registerdns' ]] && [[ "" != "$(ip address | awk '/'$VIP'/{print $0}')" ]] ); then
            #####################################################
            # Register DNS
            #####################################################
            if [[ "" != "$DNSzoneFQDN" ]] && [[ "" != "$DNSserver" ]] && [[ "" != "$VCompName" ]]; then
                if [[ $VERBOSE -eq 1 ]]; then
                    echo "[$LOGHEADER] INFO: DNS zone FQDN is $DNSzoneFQDN";
                    echo "[$LOGHEADER] INFO: DNS Server is $DNSserver";
                fi

                # Authentication by $VCompName Computer account
                KINITEXITCODE=-1
                if [[ "OK" == "$JOINED_OK" ]]; then
                    echo "$VCompPassword" | kinit $VCompName$ >/dev/null && KINITEXITCODE=$?
                fi

                # AddOrUpdateDNSRecord
                if [[ ! -z $VCompPassword ]] && [[ $KINITEXITCODE -eq 0 ]]; then
                    # Active Directory\SAMBA authentication under Computer Account is success.
                    NSUPDATERESULT=$( (echo "server $DNSserver"; echo "zone $DNSzoneFQDN"; echo "update delete $VCompNameFQDN A"; echo send; echo "update add $VCompNameFQDN $TTL A $VIP"; echo send) | nsupdate -g -v 2>&1)
                    EXITMSG=$(echo "$NSUPDATERESULT" | awk -F": " '{if ($1~/failed/) print $0}');
                    if [[ "" == "$EXITMSG" ]]; then
                        echo "[$LOGHEADER] INFO: Registering $VCompNameFQDN on $DNSserver with secure DNS update SUCCEEDED";
                    else
                        echo "[$LOGHEADER] ERROR: Registering $VCompNameFQDN on $DNSserver with secure DNS update FAILED with error: $EXITMSG.";
                    fi
                else
                    # Active Directory\SAMBA authentication is failed. Try to non-secure DNS-update.
                    NSUPDATERESULT=$( (echo "server $DNSserver"; echo "zone $DNSzoneFQDN"; echo "update delete $VCompNameFQDN A"; echo send; echo "update add $VCompNameFQDN $TTL A $VIP"; echo send) | nsupdate -v 2>&1)
                    EXITMSG=$(echo "$NSUPDATERESULT" | awk -F": " '{if ($1~/failed/) print $0}');
                    if [[ "" == "$EXITMSG" ]]; then
                        echo "[$LOGHEADER] INFO: Registering $VCompNameFQDN on $DNSserver with non-secure DNS update SUCCEEDED";
                    else
                        echo "[$LOGHEADER] ERROR: Registering $VCompNameFQDN on $DNSserver with non-secure DNS update FAILED with error: $EXITMSG.";
                    fi
                fi
            fi

            fi
            #####################################################
            # Enable DNS Update cron task if service_ip exists
            #####################################################
            # Remove cron task
            sudo crontab -u $(whoami) -l | grep -v "$0" | sudo crontab -u $(whoami) -
            if [[ -z $(ip address | awk '/'$VIP'/{print $0}') ]]; then
                # service_ip not exists
                if [[ $VERBOSE -eq 1 ]]; then
                    echo "[$LOGHEADER] INFO: service_ip not exists.";
                    echo "[$LOGHEADER] INFO: 'Dynamic DNS Update' cron task for $(whoami) user removed.";
                fi
            else
                # service_ip exists - Add cron task for Dynamic DNS Updates
                sudo crontab -u $(whoami) -l 2>/dev/null; echo "53 00 * * * sudo $0 -vips '$VIPs' -pwdfile '$VCompPasswordFile' -dnszonefqdn '$DNSzoneFQDN' -dnsserver '$DNSserver' -ttl '$TTL' -- on_schedule registerdns $VCompName" | sudo crontab -u $(whoami) -
                echo "[$LOGHEADER] INFO: 'Dynamic DNS Update' cron task for $(whoami) user (re)enabled.";
            fi
            ;;
        * )
            usage
            ;;
    esac
fi
