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


#### 4.1 Contributing with Gitpod

Gitpod is a cloud-based development environment platform that allows you to contribute to projects without setting up a local environment. You can use Gitpod to work on the `postgresql_cluster` project by following these steps:

1. **Sign up for Gitpod**: If you don't have a Gitpod account, sign up at https://gitpod.io using your GitHub account.

2. **Create a new fork**: If you haven't already, fork the `postgresql_cluster` repository by clicking the "Fork" button on the top-right corner of the repository's GitHub page (https://github.com/vitabaks/postgresql_cluster).

3. **Open your fork in Gitpod**: Replace the `username` in the following URL with your GitHub username and open it in a new browser tab: `https://gitpod.io/#https://github.com/username/postgresql_cluster`. This will launch a new Gitpod workspace with the `postgresql_cluster` project.

4. **Create a new branch**: In the Gitpod terminal, create a new branch for your changes:

   ```
   git checkout -b my-feature-branch
   ```

   Replace `my-feature-branch` with a descriptive name for your branch.

5. **Make your changes**: Modify the code, add new features, or fix existing issues in the project. Make sure to follow the project's coding guidelines and style.

6. **Commit your changes**: Once you've made your changes, stage and commit them using the following commands:

   ```
   git add .
   git commit -m "Add a brief description of your changes"
   ```

   Replace the commit message with a clear and concise description of your changes.

7. **Test your changes with Molecule**: Before committing your changes, ensure that they work correctly by running tests with Molecule. You can do this using either `make molecule-test` or `make molecule-converge`.

   If you want to test a specific distribution, set `distro`, optionally `tag`, and `namespace`:

   ```
   IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=debian10 make molecule-converge
   IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=debian11 make molecule-converge
   IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=ubuntu2004 make molecule-converge
   IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=ubuntu2204 make molecule-converge
   IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=rockylinux8 make molecule-converge
   IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=rockylinux9 make molecule-converge
   IMAGE_NAMESPACE=glillico IMAGE_DISTRO=almalinux8 make molecule-converge
   IMAGE_NAMESPACE=glillico IMAGE_DISTRO=almalinux9 make molecule-converge
   IMAGE_NAMESPACE=glillico IMAGE_DISTRO=oraclelinux8 make molecule-converge
   IMAGE_NAMESPACE=glillico IMAGE_DISTRO=oraclelinux9 make molecule-converge
   IMAGE_NAMESPACE=glillico IMAGE_DISTRO=centosstream8 make molecule-converge
   IMAGE_NAMESPACE=glillico IMAGE_DISTRO=centosstream9 make molecule-converge
   ```

8. **Push your changes**: Push your changes to your fork on GitHub:

   ```
   git push origin my-feature-branch
   ```

   Replace `my-feature-branch` with the name of the branch you created in step 4.

9. **Create a pull request**: Go to your forked repository on GitHub and click on the "Pull requests" tab. Click on the "New pull request" button, select your branch from the "compare" dropdown, and follow the instructions to create a pull request.

10. **Wait for a review**: Your pull request will be reviewed by the project maintainers. They may request changes or provide feedback before merging your changes.

Remember to keep your Gitpod workspace up-to-date with the main repository by regularly syncing your fork and merging or rebasing the changes.

#### 4.2 Contributing on your desktop

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
IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=debian10 make molecule-converge
IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=debian11 make molecule-converge
IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=ubuntu2004 make molecule-converge
IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=ubuntu2204 make molecule-converge
IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=rockylinux8 make molecule-converge
IMAGE_NAMESPACE=geerlingguy IMAGE_DISTRO=rockylinux9 make molecule-converge
IMAGE_NAMESPACE=glillico IMAGE_DISTRO=almalinux8 make molecule-converge
IMAGE_NAMESPACE=glillico IMAGE_DISTRO=almalinux9 make molecule-converge
IMAGE_NAMESPACE=glillico IMAGE_DISTRO=oraclelinux8 make molecule-converge
IMAGE_NAMESPACE=glillico IMAGE_DISTRO=oraclelinux9 make molecule-converge
IMAGE_NAMESPACE=glillico IMAGE_DISTRO=centosstream8 make molecule-converge
IMAGE_NAMESPACE=glillico IMAGE_DISTRO=centosstream9 make molecule-converge
```
Once it starts to work, you can push your code.

### [5. Make a pull request](#5-make-a-pull-request)

[GitHub](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork) has information on making pull requests.

In the comment box, you can [refer to the issue number](https://help.github.com/en/github/writing-on-github/autolinked-references-and-urls) by using #123, where 123 is the issue number.

### [6. Wait](#6-wait)

Now I'll get a message that you've added some code. Thank you, really.

CI starts to test your changes. You can follow the progress on GitHub.

Please consider sponsoring me via [github](https://github.com/sponsors/vitabaks) or [patreon](https://patreon.com/vitabaks).