[ -d /opt/local/bin ] && path=(/opt/local/bin /opt/local/sbin $path)
cdpath=(~ ..) # have cd go to ~ or parent

# if you're root, add some new directories to path
if (( EUID == 0 )); then
	path=($path /sbin /usr/sbin /usr/local/sbin)
fi
path=(/usr/local/bin $path)

manpath=($manpath /usr/X11R6/man /uns/man /usr/man /usr/lib/perl5/man) ## EDIT ##

# remove dupes
typeset -U path cdpath manpath fpath

## The file to save the history in when an interactive shell exits.
## If unset, the history is not saved.
HISTFILE=${HOME}/.zsh_history

## The maximum number of events stored in the internal history list.
HISTSIZE=64

## The maximum number of history events to save in the history file.
#SAVEHIST=64

## maximum size of the directory stack.
DIRSTACKSIZE=32

## file for mail checking
#MAIL=/var/mail/$USERNAME

## The interval in seconds between checks for new mail.
#MAILCHECK=60

## The interval in seconds between checks for login/logout activity
## using the watch parameter.
LOGCHECK=60

## The format of login/logout reports if the watch parameter is set.
## Default is `%n has %a %l from %m'.
## Recognizes the following escape sequences:
## %n = name of the user that logged in/out.
## %a = observed action, i.e. "logged on" or "logged off".
## %l = line (tty) the user is logged in on.
## %M = full hostname of the remote host.
## %m = hostname up to the first `.'.
## %t or %@ = time, in 12-hour, am/pm format.
## %w = date in `day-dd' format.
## %W = date in `mm/dd/yy' format.
## %D = date in `yy-mm-dd' format.
#WATCHFMT='%n %a %l from %m at %t.'

# Return color labeling to the ls command
# http://www.macosxhints.com/article.php?story=20031025162727485
# The colors can be set with the LSCOLORS variable. The color designators are as follows:
# 
# a     black 
# b     red 
# c     green 
# d     brown 
# e     blue 
# f     magenta 
# g     cyan 
# h     light grey 
# A     bold black, usually shows up as dark grey 
# B     bold red 
# C     bold green 
# D     bold brown, usually shows up as yellow 
# E     bold blue 
# F     bold magenta 
# G     bold cyan 
# H     bold light grey; looks like bright white 
# x     default foreground or background 
# 
# Note that the above are standard ANSI colors. The actual display may differ depending on the color capabilities of the terminal in use. The order of the attributes in the LSCOLORS variable is as follows:
# 
#    1. directory
#    2. symbolic link
#    3. socket
#    4. pipe
#    5. executable
#    6. block special
#    7. character special
#    8. executable with setuid bit set
#    9. executable with setgid bit set
#   10. directory writable to others, with sticky bit
#   11. directory writable to others, without sticky bit


# "old" GNU way of colors
LS_COLORS='no=00;32:fi=00:di=00;34:ln=01;36:pi=04;33:so=01;35:bd=33;04:cd=33;04:or=31;01:ex=00;32:*.  rtf=00;33:*.txt=00;33:*.html=00;33:*.doc=00;33:*.pdf=00;33:*.ps=00;33:*.sit=00;31:*.hqx=00;31:*.bin= 00;31:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.  gz=00;31:*.deb=00;31:*.dmg=00;36:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=0 0;35:*.xpm=00;35:*.tif=00;35:*.mpg=00;37:*.avi=00;37:*.gl=00;37:*.dl=00;37:*.mov=00;37:*.mp3=00;35:'
export LS_COLORS

export CLICOLOR=1
#export LSCOLORS=ExGxFxCxBxegedhbhgacad
export NAME="djk29a"
export EMAIL="djk29a@gmail.com"

# following containts excerpts from
# https://github.com/sindresorhus/pure
# MIT License


# Change this to your own username
DEFAULT_USERNAME='djk29a'

# Threshold (sec) for showing cmd exec time
CMD_MAX_EXEC_TIME=5

# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

zstyle ':completion:*' menu select

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git*' formats ' %b'
zstyle ':vcs_info:git*' actionformats ' %b|%a'
zstyle ':vcs_info:svn*' formats ' %b'
zstyle ':vcs_info:svn*' actionformats ' %b|%a'

# Only show username if not default
[ $USER != $DEFAULT_USERNAME ] && local username='[%n@%m] '

# Fastest possible way to check if repo is dirty
git_dirty() {
		git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo '*'
}

# Displays the exec time of the last command if set threshold was exceeded
cmd_exec_time() {
		local stop=`date +%s`
		local start=${cmd_timestamp:-$stop}
		let local elapsed=$stop-$start
		[ $elapsed -gt $CMD_MAX_EXEC_TIME ] && echo ${elapsed}s
}

# Override
preexec() {
		cmd_timestamp=`date +%s`
}

# Override
precmd() {
		vcs_info
		# Add `%*` to display the time
		print -P "\n%B%~%F{green}${vcs_info_msg_0_}`git_dirty`%f $username %F{yellow}`cmd_exec_time`%f"
		# Reset value since `preexec` isn't always triggered
		unset cmd_timestamp
}

# Prompt turns red if the previous command didn't exit with 0
PROMPT='%(?.%F{green}.%F{red}[%?])❯%f '
