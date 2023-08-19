---
created: 2023-08-19T19:32:55 (UTC +04:00)
tags: []
source: https://www.elliotdenolf.com/blog/bootstrap-your-dotfiles-with-dotbot
author: Elliot DeNolf
---

# Bootstrap your Dotfiles with dotbot

> ## Excerpt
> A customized set of dotfiles can vastly increase your command-line productivity and happiness. In this tutorial, we'll be setting up a dotfiles repository and bootstrapping it using dotbot

---
A customized set of dotfiles can vastly increase your command-line productivity and happiness. Having your dotfiles in a repo allows you to take your configuration anywhere. In this tutorial, we'll be setting up a dotfiles repository and bootstrapping it using [dotbot](https://github.com/anishathalye/dotbot/).

## Why Dotbot?

While it could be tempting for some to script your dotfiles configuration and installation yourself, I would advise against going this route. I previously went this route, but I would constantly run into edge-cases leading to constant modification of the scripts. With a framework, most of the use-cases have been thought of, so it is very low friction in comparison.

On investigating a number of tools out there, dotbot's features set it apart from the others:

-   Single configuration file
-   Single command to install on a new machine via symbolic links
-   Can be added as a git submodule
-   Python is the only dependency (standard for almost all distros)

## Getting Started

The first step is to get a git repository started and add dotbot as a submodule

```
# Create project directory
mkdir dotfiles
cd dotfiles

# Initialize Repository
git init
git submodule add https://github.com/anishathalye/dotbot
cp dotbot/tools/git-submodule/install .
touch install.config.yaml
```

So now we have a few things set up:

-   New git repository
-   Dotbot added as a submodule
-   Dotbot's `install` script copied to the project root
-   A blank configuration file

## Configuration

Next, we'll start modifying our config file. Here is a starting point:

```
- defaults:
    link:
      relink: true

- clean: ['~']

- link:
    ~/.bashrc: bashrc
    ~/.zshrc: zshrc
    ~/.vimrc: vimrc

- shell:
    - [git submodule update --init --recursive, Installing submodules]
```

Let's go through each section to see what it does

### Defaults

Defaults controls what action will be taken for everything in the `link` section. `relink` removes the old target if it is a symlink. There are additional options that may be worth looking at in the documentation

### Clean

This simply defines what directory should be inspected for dead links. Dead links are automatically removed.

### Link

This is where most of your modifications will take place. Here we define where we want the symlink to be once linked, and what file should be linked there. In the above example, we have 3 files that commonly contain customizations.

### Shell

This section contains any raw shell commands that you'd like to run upon running your install script. In this case, it installs any submodules.

## Move files into Repository

Next, we move the files we want to link into our repository. Assuming you want the 3 files specified from above, we can run the following commands to move them in.

```
cp ~/.vimrc ./vimrc
cp ~/.zshrc ./zshrc
cp ~/.bashrc ./bashrc
```

### Run Install Script

We can test out if everything works properly by running `./install` within our repository. If all is configured properly, you should see something like the following:

```
./install
All targets have been cleaned
Creating link ~/.bashrc -> ~/.dotfiles/bashrc
Creating link ~/.zshrc -> ~/.dotfiles/zshrc
Creating link ~/.vimrc -> ~/.dotfiles/vimrc
All links have been set up
Installing submodules [git submodule update --init --recursive]
All commands have been executed

==> All tasks executed successfully
```

Once you are satisfied with how you dotfiles install, be sure to commit your changes and push to a remote repository.

```
git add --all
git remote add origin git@github.com:username/dotfiles.git
git push -u origin master
```

### Use on Multiple Machines

Now that you have a basic dotfiles repository set up, you can push this to a public repository in order to use on multiple machines. On any machine, you can now simply run the following commands to install your dotfiles:

```
git clone git@github.com:username/dotfiles.git --recursive
cd dotfiles && ./install
```

Any new changes can be retrieved from the repository and installed using the following commands:

## Summary

You can now easily maintain your dotfiles in a git repository and share them between your environments.

Here is my [personal dotfiles](https://github.com/denolfe/dotfiles) repository that uses dotbot. There are many other places to draw dotfiles inspiration from such as [GitHub Does Dotfiles](http://dotfiles.github.io/) and [other dotbot users](https://github.com/anishathalye/dotbot/wiki/Users).
