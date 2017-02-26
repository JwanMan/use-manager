# use-manager
A really simple script/use-case manager.

This is a tiny, public domain, shell program to manage your scripts and use cases (an use case is a script used to open anything you need to perform a task). The scripts you manage with this program should have a sha-bang (#!) line, as this utility is meant to be independent from the programming language.

Installation
-----------

This program runs on every UNIX-like operating system (such as Linux) that has the Bourne-Again Shell (bash) installed.

To install it, clone this repo, copy the `use` file somewhere on your path and, if you want to access from the desktop, copy the `use.desktop` file to `/usr/share/applications`. In other words:
```
cd `mktemp -d`
git clone https://github.com/JwanMan/use-manager.git
cd use-manager
mv use /usr/local/bin/
mv use.desktop /usr/share/applications/
```

Configuration
------------

The program behaviour can be modified by the following environment variables:
* `USE_DIR`: The directory where the scripts are stored. By default, it's `~/.userc`.
* `EDITOR`: The program to be used to edit the scripts, plus any additional parameters. By default, it's `nano`.
* `SHOW`: The program to show the scripts. By default, it's `less`.
