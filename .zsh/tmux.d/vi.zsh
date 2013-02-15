#!/usr/bin/env zsh
source "$ZDOTDIR/tmux.d/common.zsh"

sid=`tmux display-message -p '#S'`
# Get session/window ids
# Lets see if we are in a project
dir="`pwd`"
vim_id_pattern=""
while [ -n "$dir" ] ; do
	# Only work with svn 1.7 +
	[[ -d "$dir/.git" ||\
		-d "$dir/.svn" ||\
		-d "$dir/.hg"  ||\
		-d "$dir/.bzr" ]] && break
	# go up one level
	dir=${dir%/*}
done
# vim servernames are case-insensitive, so we cant use directory
# names as parts of the servername(it would generate ambiguities
# with names which differ only in case), so each directory/sid 
# pair is mapped to a unique id, which will be used as servername
#
# since the directory->uuid mapping is global(not specific to a
# zsh instance) the data will be stored in the shared memory
# daemon, which will also synchronize access to the data.
default=`uuidgen`
# convert to uppercase since thats how vim display the servers
default=${default:u}
# append the session id to the key, because vim instances are
# session-specific
dir_id=`_shm_get "$dir:$sid" $default`
vim_id_pattern=":${dir_id}:"
vim_id=`vim --serverlist | grep -F "$vim_id_pattern"`
if [ -z $vim_id ]; then
	# vim is not running, so start a new instance 
	#
	# Before we can send commands to the new instance, it must be fully
	# started, so we need to syncronize the startup with this function using a
	# unique named pipe, which will also allow us to get the new pane id
	fifo="/tmp/tmux-vim-pane-$RANDOM"
	while ! mkfifo $fifo > /dev/null 2>&1; do
		fifo="/tmp/tmux-vim-pane-$RANDOM"
	done
	# g:project_dir can be used by vim scripts that need to know the project
	# root directory
	tmux split-window -d -p 70 "vim \
		-c \"cd $dir\" \
		-c \"let g:project_dir='$dir'\" \
		-c vim -c ':silent !echo \$TMUX_PANE >> $fifo'\
		--servername \":$dir_id:\${TMUX_PANE#*\%}\""
	pane_id=`cat $fifo`
	# will only get here after vim has started
	pane_id=${pane_id#*\%}
	rm $fifo
	vim_id=":$dir_id:$pane_id"
	# now we associate the two panes in shared memory, so we can more easily
	# break/join them toguether
	_shm_set "$pane_id" "${TMUX_PANE#*\%}:bottom"
	_shm_set "${TMUX_PANE#*\%}" "${pane_id}:top"
fi
# open all files
vim --servername "$vim_id" --remote-send "<ESC>"
while [ $# -ne 0 ]; do
	vim --servername "$vim_id" --remote-send ":e ${(q)1:a}<CR>"
	shift
done
# extract the unique pane id from vim_id and navigate to it
pane_uid="%${vim_id#\:$dir_id\:}"
window_uid="`tmux display-message -pt \"$pane_uid\" '#{window_id}'`"
tmux select-window -t "$window_uid"
tmux select-pane -t "$pane_uid"
