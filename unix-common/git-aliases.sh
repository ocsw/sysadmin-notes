#!/usr/bin/env bash

# NOTE: must be run directly, not with (e.g.) 'bash git-aliases.sh'

# broken out of git-config.sh so the aliases can be (re)applied separately


##########################
# clear existing aliases #
##########################

# remove the below aliases if they exist, so that when we re-add them, they
# will be in order; we also need to keep a fake alias in place so the alias
# section stays where it is in the config file (relative to includes, for
# example)
git config --global alias.faketempalias temp
sed 's/^ *//' "$0" | sed 's/ *#.*$//' | grep '^git config --global alias\.' | \
    awk '{print $4}' | grep -v '^alias.faketempalias$' | \
    while read -r alias; do
        git config --global --unset "$alias"
    done


###############
# add aliases #
###############

#
# meta
#
git config --global alias.h help
# (not going to make 4 each of set, get, unset, list, edit)
git config --global alias.cf config  # local, or current
git config --global alias.cff 'config --file'
git config --global alias.cfg 'config --global'
git config --global alias.cfs 'config --system'
git config --global alias.cfo 'config --show-origin'
git config --global alias.cflo 'config -l --show-origin'
git config --global alias.la '!git config --global -l | grep ^alias | cut -c 7-'
git config --global alias.las \
    '!git config --global -l | grep ^alias | cut -c 7- | sort'
git config --global alias.lah '!git help -a | sed -e "1,/^Command aliases\$/d"'

#
# repo management
#
git config --global alias.in init
git config --global alias.cl clone
git config --global alias.rem remote
# leaving out fsck and gc (rarely used, to be used carefully, and hard to
# abbreviate)

#
# branch and tag management
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
# switch is new in git 2.23
git config --global alias.sw switch
git config --global alias.swc 'switch -c'
git config --global alias.swd 'switch --detach'
git config --global alias.tagl 'tag -l'
git config --global alias.tagdel 'tag -d'
# don't use -a (annotated and unsigned); it overrides tag.forcesignannotated,
# whereas using -m implies an annotated tag but allows it to be signed
# (note: git 2.23 introduced tag.gpgsign, which overrides even -a, but it also
# prevents making lightweight (non-annotated) tags)
git config --global alias.tagm 'tag -m'
# shellcheck disable=2016
git config --global alias.tagnm '!sh -c "git tag \"$1\" -m \"$2\"" sh'

#
# status, history, contents
#
git config --global alias.st status
git config --global alias.l log
git config --global alias.lg 'log --graph'
git config --global alias.lf 'log --numstat'  # files
git config --global alias.ld 'log --patch'  # diff
git config --global alias.ll 'log --oneline'
# see git-config.sh for formats
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
git config --global alias.bi bisect
git config --global alias.bist 'bisect start'
git config --global alias.big 'bisect good'
git config --global alias.bib 'bisect bad'
git config --global alias.bin 'bisect new'
git config --global alias.bio 'bisect old'
git config --global alias.bisk 'bisect skip'
git config --global alias.biv 'bisect view'
git config --global alias.bil 'bisect log'
git config --global alias.birs 'bisect reset'
git config --global alias.birp 'bisect replay'

#
# workstream management (stacks of commits; single commands)
#
git config --global alias.ft fetch
git config --global alias.fta 'fetch --all'
git config --global alias.pl pull
git config --global alias.pla 'pull --all'
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
git config --global alias.rbih '!sh -c "git rebase -i \"HEAD~$1\"" sh'
git config --global alias.mg merge
git config --global alias.mgn 'merge --no-ff'
git config --global alias.mga 'merge --abort'
git config --global alias.mgc 'merge --continue'
git config --global alias.cp cherry-pick
git config --global alias.cpe 'cherry-pick --edit'
git config --global alias.cpn 'cherry-pick --no-commit'
git config --global alias.cpa 'cherry-pick --abort'
git config --global alias.cpc 'cherry-pick --continue'
git config --global alias.rv revert
git config --global alias.rvf 'revert --no-edit'
git config --global alias.rvn 'revert --no-commit'
git config --global alias.rva 'revert --abort'
git config --global alias.rvc 'revert --continue'
git config --global alias.rrr rerere
git config --global alias.rrrs 'rerere status'
git config --global alias.rrrd 'rerere diff'

#
# workstream management (stacks of commits; multiple commands)
#
# for rebase -i edits and merge conflicts
# note: for an edit, staged changes will be automatically amended onto the
# previous commit; for a conflict, they will become the next commit
git config --global alias.arbc '!git add -A && git rebase --continue'
git config --global alias.amgc '!git add -A && git merge --continue'
git config --global alias.acpc '!git add -A && git cherry-pick --continue'
git config --global alias.arvc '!git add -A && git revert --continue'

#
# editing (file-level changes)
#
git config --global alias.ss stash
git config --global alias.ssl 'stash list'
git config --global alias.sss 'stash show'
git config --global alias.ssm 'stash push -m'
git config --global alias.ssp 'stash pop'
git config --global alias.ssa 'stash apply'
git config --global alias.ssd 'stash drop'
git config --global alias.ssc 'stash clear'
# leaving out mv and rm (too short to abbreviate), and clean (dangerous and
# rarely used)

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


#######################
# clean up fake alias #
#######################

git config --global --unset alias.faketempalias