# [Please contribute](#please-contribute)

You can really make a difference by:

- [Making an issue](https://help.github.com/articles/creating-an-issue/). A well-described issue helps a lot. (Check the [known issues](https://github.com/search?q=user%3Avitabaks+is%3Aissue+state%3Aopen) first.)
- [Making a pull request](https://docs.github.com/fr/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) when you find an error in the code.

I will try to help and take every contribution seriously.

This is a great opportunity for me to learn how you use the role and also an opportunity for you to get into the habit of contributing to open-source software.

## [Step by step](#step-by-step)

Here is how you can help, many steps are related to GitHub, not specifically to this project.

### [1. Make an issue.](#1-make-an-issue)

When you spot an issue, [create an issue](https://github.com/vitabaks/postgresql_cluster/issues).

Making the issue helps me and others to find similar problems in the future.

### [2. Fork the project.](#2-fork-the-project)

On the top right side of [the repository on GitHub](https://github.com/vitabaks/postgresql_cluster), click `fork`. This copies everything to your GitHub namespace.

### [3. Make the changes](#3-make-the-changes)

In your GitHub namespace, make the required changes.

I typically do that by cloning the repository (in your namespace) locally:

```
git clone git@github.com:YOURNAMESPACE/postgresql_cluster.git
```

Now you can start editing on your laptop.

### [4. Test your changes](#4-optionally-test-your-changes)

Install [make](https://www.gnu.org/software/make/) and [Python3.10](https://www.python.org/) with [venv](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/) :

```
sudo apt update
sudo apt install -y make python3.10 python3.10-venv
python3 -m pip install --upgrade pip
python3 -m pip install virtualenv
```

You also need [docker](https://docs.docker.com/engine/install/ubuntu/) installed.

And run `make`. You will see help from Makefile

```
make
```

Run `make reinitialization` or `make bootstrap` for initializing the virtualenv and installing all dependencies.

Then, run the test with `make molecule-test` or `make molecule-converge` for only the converge sequence.

If you want to test a specific distribution, set `distro`, optionally `tag`, and `namespace` :

```
IMAGE_DISTRO=rockylinux9 IMAGE_TAG=latest IMAGE_NAMESPACE=geerlingguy make molecule-converge
```

Once it starts to work, you can push your code.

### [5. Make a pull request](#5-make-a-pull-request)

[GitHub](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork) has information on making pull requests.

In the comment box, you can [refer to the issue number](https://help.github.com/en/github/writing-on-github/autolinked-references-and-urls) by using #123, where 123 is the issue number.

### [6. Wait](#6-wait)

Now I'll get a message that you've added some code. Thank you, really.

CI starts to test your changes. You can follow the progress on GitHub.

Please consider [sponsoring me](https://patreon.com/vitabaks).