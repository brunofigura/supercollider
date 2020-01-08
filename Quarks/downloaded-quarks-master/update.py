#!/usr/bin/env/python
"""
update.py

Using the directory.txt file,
clone or update one or all repositories.

After any updates to the directory.txt file, run this script
to update and fetch all the sub repositories.

Usage::
    pip install requests

    # update all
    python update.py

    # update one
    python update.py quarkname

directory.txt format::

    # latest commit on default master branch
    quarkname=git://github.com/author/quarkname
    # tag (recommended for stable releases)
    quarkname=git://github.com/author/quarkname@tags/4.1.3
    # pin to a specific commit
    quarkname=git://github.com/author/quarkname@0214d3a0e805146cfbaded090da1a2aabebcec2c

"""
import sys
import re
import shutil
import os.path
import subprocess
import requests


if(len(sys.argv) > 1):
    quark = sys.argv[1]
else:
    quark = None


def parse(line):
    return re.match(r'^(?P<name>[a-zA-Z0-9\_\-\.]+)=(?P<url>[^@]+)@?(?P<refspec>.*)$', line)


def update(match):
    name = match.group('name')
    url = match.group('url')
    refspec = match.group('refspec')
    print("\nUpdating: {0} {1} {2}".format(name, url, refspec))

    quark_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), name)
    exists = os.path.exists(name)
    if exists:
        # check if repository URL has been changed
        current = subprocess.check_output("cd {}; git config --get remote.origin.url".format(quark_dir), shell=True).strip().decode('UTF-8')
        if current != url:
            print("Repository URL has changed, was: {} is now: {}, removing copy at: {}".format(current, url, quark_dir))
            shutil.rmtree(quark_dir)
            exists = False
    # clone the repo
    if not exists:
        print("git clone {} {}".format(url, name))
        err = subprocess.call(["git", "clone", url, name])
        if err:
            raise Exception("Failed to clone %s" % url)
    # checkout any tag or hash
    if refspec:
        print("git checkout".format(refspec, name))
        err = subprocess.Popen(["git", "checkout", refspec], cwd=quark_dir).wait()
        if err:
            raise Exception("Failed to checkout %s %s" % (url, refspec))
    else:
        # get latest
        print("git pull {} {}".format(name, url))
        err = subprocess.Popen(["git", "pull"], cwd=quark_dir).wait()
        if err:
            # if not on a branch due to a refspec
            print("WARNING did not pull {} {}".format(name, url))
    # stage any changes
    err = subprocess.call(["git", "add", "%s/*" % name])
    if err:
        raise Exception("Failed to git add %s/*" % name)


response = requests.get('https://raw.githubusercontent.com/supercollider-quarks/quarks/master/directory.txt')
response.raise_for_status()
for line in response.text.split('\n'):
    line = line.strip()
    if quark:
        m = parse(line)
        if line and (not m):
            print("Broken line in directory.txt: {}".format(line))
            continue
        if quark == m.group('name'):
            update(m)
            exit(0)
    else:
        m = parse(line)
        if not m:
            print("Broken line in directory.txt: {}".format(line))
            continue
        try:
            update(m)
        except Exception as e:
            print("Error: {line} {e}".format(line=line, e=e))

print("Complete")
