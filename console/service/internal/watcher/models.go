package watcher

type LogEntity struct {
	Task    string      `json:"task"`
	Failed  bool        `json:"failed"`
	Msg     interface{} `json:"msg"`
	Summary interface{} `json:"summary,omitempty"`
	Status  string      `json:"status"`
}

type SystemInfo struct {
	ServerLocation *string `json:"server_location,omitempty" mapstructure:"server_location"`
	ServerName     string  `json:"server_name" mapstructure:"server_name"`
	IpAddress      string  `json:"ip_address" mapstructure:"ip_address"`
}
