#!/usr/bin/env zsh
# Simple vim/tmux integration script for zsh.
#
# Open one vim instance per project, if a project file is
# opened and there is a running vim instance for that project, then open in it
# alias this script in zsh if running inside tmux
#
# requires tmux monitor patch:
# http://sourceforge.net/mailarchive/forum.php?thread_name=CAAq2XdqyKOMj4%2BVFySA9Qbmi0K4jym%2B0sH-z%2BADJT9ijRKzj2w%40mail.gmail.com&forum_name=tmux-users

while (( $# != 0 )); do
	file=${1:a}
	dir=${file:h}
	while [[ -n $dir ]] ; do
		# Only work with svn 1.7 +
		[[ -d "$dir/.git" ||\
			-d "$dir/.svn" ||\
			-d "$dir/.hg"  ||\
			-d "$dir/.bzr" ]] && break
		# go up one level
		dir=${dir:h}
	done
	file=${file#$dir/}
	lock="vim-edit:$dir"
	tmux monitor -l $lock # to be safe, synchroninze access to the vim pane
	vim_pane=`tmux show -v "@$lock" 2> /dev/null`
	if [[ -z $vim_pane ]] || ! tmux display-message -pt $vim_pane &> /dev/null; then
		# vim is not running in any pane, so start a new instance 
		#
		# g:project_dir can be used by vim scripts that need to know the project
		# root directory
		monitor="`uuidgen`"
		tmux split-window -d -p 70 "vim \
			-c \"cd $dir\" \
			-c \"let g:project_dir='$dir'\" \
			-c ':silent !tmux set -q \"@$lock\" \"\$TMUX_PANE\"'\
			-c ':silent !tmux monitor -s \"$monitor\"'"
		tmux monitor -w $monitor
		vim_pane=`tmux show -v "@$lock" 2> /dev/null`
	fi
	# open all files
	tmux send-keys -t $vim_pane 'Escape' ":e ${file:q}" 'Enter'
	window_uid="`tmux display-message -pt \"$vim_pane\" '#{window_id}'`"
	tmux monitor -u $lock
	shift
done

if [[ -n $window_uid && -n $vim_pane ]]; then
	tmux select-window -t $window_uid
	tmux select-pane -t $vim_pane
fi
