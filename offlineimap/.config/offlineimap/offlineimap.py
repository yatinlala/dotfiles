#!/usr/bin/env python2

from subprocess import check_output

def getPassword():
    return check_output("gpg --batch --quiet --decrypt " + 
            "~/.local/passwords/mutt.gpg",
            shell=True).strip("\n")
