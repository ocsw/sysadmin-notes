#!/usr/bin/env bash

############
# identity #
############

# fence these so we can re-run this file without breaking anything
if ! git config --global --get user.name > /dev/null; then
    git config --global user.name 'Danielle Zephyr Malament'
fi
if ! git config --global --get user.email > /dev/null; then
    git config --global user.email danielle.malament@gmail.com
fi
if ! git config --global --get user.signingkey > /dev/null; then
    # not necessary if the default key is the one you want
    git config --global user.signingkey KEY_ID
fi


####################
# command settings #
####################

#
# core
#
git config --global core.pager 'less -F'
git config --global core.excludesfile ~/.gitignore_global
# for GUI systems
if ! grep '^\.vscode$' ~/.gitignore_global > /dev/null 2>&1; then
    echo '.vscode' >> ~/.gitignore_global
fi

#
# formatting
#
# for logging aliases, below
git config --global pretty.oneline-name \
    '%C(yellow)%h%Cgreen%d %Creset%s%Cblue [%cn]'
git config --global pretty.oneline-name-nl \
    '%n%C(yellow)%h%Cgreen%d %Creset%s%Cblue [%cn]'

#
# GPG signing
#
git config --global commit.gpgsign true
git config --global tag.forcesignannotated true


###########
# aliases #
###########

#
# clear existing
#
# remove the below aliases if they exist, so that when we re-add them, they
# will be in order
sed 's/^ *//' "${0:-git-config.sh}" | \
    sed 's/ *#.*$//' | grep '^git config --global alias\.' | awk '{print $4}' |
    while read -r alias; do
        git config --global --unset "$alias"
    done

#
# meta
#
git config --global alias.h help
git config --global alias.la '!git config -l | grep ^alias | cut -c 7-'
git config --global alias.las '!git config -l | grep ^alias | cut -c 7- | sort'
git config --global alias.lah '!git help -a | sed -e "1,/^Command aliases\$/d"'

#
# branch management
#
# NOTE: don't use this if you need a branch name you can checkout back to!
# (this can give you things like '(HEAD detached at origin/master)'; use
# git-current-branch() instead in that case)
# see also https://stackoverflow.com/questions/6245570
git config --global alias.cur \
    '!git branch --no-color | sed -n "/^\* /  s/^..//p"'
# prints the current branch, or fails with no output if we're not on a
# local branch (e.g. detached HEAD)
# see also https://stackoverflow.com/questions/6245570
git config --global alias.curb 'symbolic-ref --short -q HEAD'
git config --global alias.br branch
git config --global alias.brdel 'branch -d'
git config --global alias.brdelf 'branch -D'
git config --global alias.co checkout
git config --global alias.cb 'checkout -b'
git config --global alias.back 'checkout -'

#
# status, history, contents
#
git config --global alias.st status
git config --global alias.l log
git config --global alias.lg 'log --graph'
git config --global alias.lf 'log --numstat'  # files
git config --global alias.ld 'log --patch'  # diff
git config --global alias.ll 'log --oneline'
git config --global alias.lln 'log --pretty=oneline-name'
git config --global alias.llg 'log --pretty=oneline-name --graph'
git config --global alias.llf 'log --pretty=oneline-name-nl --numstat'  # files
git config --global alias.tree 'log --pretty=oneline-name --graph --all'
git config --global alias.rl reflog
git config --global alias.s show
git config --global alias.d diff
git config --global alias.dc 'diff --cached'
git config --global alias.g grep
git config --global alias.bl blame

#
# workstream management (single commands)
#
git config --global alias.pl pull
git config --global alias.prb 'pull --rebase'
git config --global alias.prbm 'pull --rebase origin master'
git config --global alias.prbd 'pull --rebase origin develop'
git config --global alias.rb rebase
git config --global alias.rbm 'rebase master'
git config --global alias.rbd 'rebase develop'
git config --global alias.rba 'rebase --abort'
git config --global alias.rbc 'rebase --continue'
git config --global alias.rbi 'rebase -i'
# shellcheck disable=2016
git config --global alias.rbih '!sh -c "git rebase -i HEAD~$1" sh'
git config --global alias.mg merge
git config --global alias.mgn 'merge --no-ff'
git config --global alias.mga 'merge --abort'
git config --global alias.mgc 'merge --continue'
git config --global alias.pick cherry-pick
git config --global alias.ss stash
git config --global alias.ssl 'stash list'
git config --global alias.sss 'stash show'
git config --global alias.ssm 'stash push -m'
git config --global alias.ssp 'stash pop'
git config --global alias.ssa 'stash apply'
git config --global alias.ssd 'stash drop'
git config --global alias.ssc 'stash clear'
git config --global alias.rrr rerere
git config --global alias.rrrs 'rerere status'
git config --global alias.rrrd 'rerere diff'

#
# workstream management (multiple commands)
#
# for rebase -i edits and merge conflicts
# note: for an edit, staged changes will be automatically amended onto the
# previous commit; for a conflict, they will become the next commit
git config --global alias.arbc '!git add -A && git rebase --continue'
git config --global alias.amgc '!git add -A && git merge --continue'

#
# add -> commit -> push (single commands)
#
git config --global alias.ap 'add -p'
git config --global alias.aa 'add -A'
git config --global alias.ci commit
git config --global alias.cm 'commit -m'
git config --global alias.amendm 'commit --amend'
git config --global alias.amend 'commit --amend --no-edit'
git config --global alias.ps push
git config --global alias.pn 'push --set-upstream origin'
git config --global alias.pnh 'push --set-upstream origin HEAD'
git config --global alias.pf 'push --force-with-lease'

#
# add -> commit -> push (multiple commands)
#
git config --global alias.acm '!git add -A && git commit -m'
git config --global alias.apf \
    '!git commit --amend --no-edit && git push --force-with-lease'
git config --global alias.aapf \
    '!git add -A && git commit --amend --no-edit && git push --force-with-lease'