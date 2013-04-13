## others can't rwx my files
umask 066

unlimit
limit stack 8192
limit core 0
limit -s
UNAME=`/usr/bin/uname`
## If set, this gives a string of characters, which can use
## all the same codes as the bindkey command as described in
## section The zsh/zle Module, that will be output to
## the terminal instead of beeping.
## This may have a visible instead of an audible effect;
## for example, the string `\e[?5h\e[?5l' on a vt100 or xterm will have
## the effect of flashing reverse video on and off (if you usually use reverse
## video, you should use the string `\e[?5l\e[?5h' instead).  This takes
## precedence over the NOBEEP option.
#ZBEEP='\e[?5h\e[?5l'

## The directory to search for shell startup files (.zshrc, etc),
## if not $HOME.
#ZDOTDIR=~/.zsh

## auto logout after timeout in seconds
#TMOUT=1800


bindkey -v  ## vi key bindings
bindkey "^R" history-incremental-search-backward

# completion 
autoload -U compinit && compinit

## set colors for GNU ls ; set this to right file
if [[ ( -f "$HOME/.colors" ) && $UNAME = 'Linux' ]]; then
	eval `dircolors $HOME/.colors`
elif [ -f /etc/DIR_COLORS ]; then
	eval `dircolors /etc/DIR_COLORS`
fi

## Color completion
## this module should be automatically loaded if u use menu selection
## but to be sure we do it here
zmodload -i zsh/complist

## This allows incremental completion of a word.
## After starting this command, a list of completion
## choices can be shown after every character you
## type, which you can delete with ^h or DEL.
## RET will accept the completion so far.
## You can hit TAB to do normal completion, ^g to            
## abort back to the state when you started, and ^d to list the matches.
autoload -U incremental-complete-word
zle -N incremental-complete-word
bindkey "^Xi" incremental-complete-word ## C-x-i

## This function allows you type a file pattern,
## and see the results of the expansion at each step.
## When you hit return, they will be inserted into the command line.
autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files ## C-x-f

## This set of functions implements a sort of magic history searching.
## After predict-on, typing characters causes the editor to look backward
## in the history for the first line beginning with what you have typed so
## far.  After predict-off, editing returns to normal for the line found.
## In fact, you often don't even need to use predict-off, because if the
## line doesn't match something in the history, adding a key performs
## standard completion - though editing in the middle is liable to delete
## the rest of the line.
autoload -U predict-on
#zle -N predict-on
#zle -N predict-off
#bindkey "^X^Z" predict-on ## C-x C-z
#bindkey "^Z" predict-off ## C-z

## watch for my friends
## An array (colon-separated list) of login/logout events to report.
## If it contains the single word `all', then all login/logout events
## are reported.  If it contains the single word `notme', then all
## events are reported as with `all' except $USERNAME.
## An entry in this list may consist of a username,
## an `@' followed by a remote hostname,
## and a `%' followed by a line (tty).
#watch=( $(<~/.friends) )  ## watch for people in $HOME/.friends file
#watch=(notme)  ## watch for everybody but me
#LOGCHECK=60  ## check every ... seconds for login/logout activity

## functions for displaying neat stuff in *term title
case $TERM in
	*xterm*|rxvt|(dt|k|E)term)
	## display user@host and full dir in *term title
#	precmd () {
		#print -Pn  "\033]0;%n@%m %~\007"
		#print -Pn "\033]0;%n@%m%#  %~ %l  %w :: %T\a" ## or use this
#		}
	## display user@host and name of current process in *term title
#	preexec () {
		#print -Pn "\033]0;%n@%m <$1> %~\007"
		#print -Pn "\033]0;%n@%m%#  <$1>  %~ %l  %w :: %T\a" ## or use this
#		}
	;;
esac

## aliases ####
#alias mplayer='mplayer -abs 1' # this was for SB SCruz sound card issues
alias v='vim'
alias vi='vim'
alias mv='nocorrect mv -i'
alias cp='nocorrect cp -i'
alias rm='nocorrect rm'
alias mkdir='nocorrect mkdir'
alias man='nocorrect man'
alias find='noglob find'
#alias ls='ls --color=auto'
alias ls='ls -G'
alias l='ls -lF'
alias la='ls -AF'
# correct typos
alias ..='cd ..'
alias cd/='cd /'
alias ftp='ftp -i'
export LC_ALL="en_US.UTF-8"

export PYTHONPATH="/opt/local/Library/Frameworks/Python.framework/Versions/2.7"

## invoke this every time when u change .zshrc to
## recompile it.
src ()
{
	autoload -U zrecompile
	[ -f ~/.zshenv ] && zrecompile -p ~/.zshenv
	[ -f ~/.zshrc ] && zrecompile -p ~/.zshrc
	[ -f ~/.zcompdump ] && zrecompile -p ~/.zcompdump
	[ -f ~/.zshrc.zwc.old ] && rm -f ~/.zshrc.zwc.old
	[ -f ~/.zcompdump.zwc.old ] && rm -f ~/.zcompdump.zwc.old
	source ~/.zshenv && source ~/.zshrc
}

readme ()
{
	local files
	files=(./(#i)*(read*me|lue*m(in|)ut)*(ND))
	if (($#files))
	then $PAGER $files
	else
		print 'No README files.'
	fi
}

local _myhosts
if [[ -r ~/.ssh/known_hosts ]]; then
	_myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
fi

zstyle -e ':completion::*:*:*:hosts' hosts $_myhosts
if [[ $#_myhosts -gt 0 ]]; then
	zstyle ':completion:*:ssh:*' hosts $_myhosts
	zstyle ':completion:*:scp:*' hosts $_myhosts
	zstyle ':completion:*:slogin:*' hosts $_myhosts
fi

## complete minimal
zstyle ':completion:*' completer _complete _ignored

## offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

## insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

## ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

## completion caching
#zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zcompcache/$HOST

## add colors to completions
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns \
'*?.(o|c~|old|pro|zwc)' '*~'

setopt extendedglob glob always_to_end
setopt NO_auto_name_dirs NO_auto_remove_slash NO_auto_resume \
 NO_beep NO_bg_nice brace_ccl NO_c_bases NO_chase_dots \
 NO_chase_links NO_check_jobs clobber NO_complete_aliases \
 complete_in_word NO_correct correct_all glob_complete \
 NO_hist_allow_clobber NO_hist_beep hist_expire_dups_first

setopt hist_find_no_dups hist_ignore_all_dups hist_ignore_dups \
hist_ignore_space hist_no_functions hist_no_store \
hist_reduce_blanks NO_hup NO_list_beep list_packed

# individual application completions
compctl -g '*.class(:r)' java
compctl -g '*.tex' + -g '*' latex
compctl -g '*.tex' + -g '*' pdflatex
compctl -g '*.ps' + -g '*' gv
compctl '-/' cd
compctl -g '*.tar.Z *.tar.gz *.tgz *.tar.bz2 *.tbz' + -g '*' tar
compctl -g '*.zip *.ZIP' + -g '*' unzip
compctl -g '*.(mp3|MP3)' + -g '*(-/)' mpg123
compctl -g '*.(ogg|OGG)' + -g '*(-/)' ogg123
compctl -g '*.(mov|MPG|AVI|MOV|vob|VOB|avi|mp3|MP3|wmv|mpg|ogg|ram|ra|mp4|asf|vqf)' + -g '*(-/)' mplayer
compctl -g '*.(pdf|PDF)' + -g '*(--/)' xpdf
compctl -g '*.(jpg|jpeg|JPG|gif|png)' + -g '*(-/)' ee
