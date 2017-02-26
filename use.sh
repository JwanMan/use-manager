#!/bin/bash
# This file is public domain.
#
# This tiny utility can be 
#
# This is an interactive command you can place on your desktop, menu
# or wherever.
#
# The scripts you manage with this should have a proper sha-bang (#!)
# line. If you want this to start a GUI, you can use nohup in the
# command line. Using nohup in the sha-bang has the potential unwanted
# effects of exploding (if you forget to put the name of the shell
# after the word 'nohup') or scattering nohup.out files all over the
# place (if you start it from different places), so it's discouraged.
#
# The environment variables affecting this are:
#  $USE_DIR: The directory to store (and read) the scripts. By
#    default, it is '~/.userc'.
#  $EDITOR: The text editor to edit the scripts. By default, it is
#    'nano'.
#  $SHOW: The default command to show the scripts (not editing). By
#    default, it is 'less' (you can use cat, nano...).


# Normalize environment variables.
USE_DIR=${USE_DIR:-~/.userc}
[ "$USE_DIR" != / ] && USE_DIR=${USE_DIR%/}

EDITOR=${EDITOR:-nano}
SHOW=${SHOW:-less}

# If if doesn't exist, create it if possible.
if [ ! -d "$USE_DIR" ]; then
	if [ -e "$USE_DIR" ]; then
		echo "$0: $USE_DIR: Not a directory."
		exit
	elif mkdir -p "$USE_DIR"; then
		echo "$0: Created directory '$USE_DIR'."
	else
		exit
	fi
fi

# Check read/list permissions.
if [ ! -r "$USE_DIR" -o ! -x "$USE_DIR" ]; then
	echo "$0: $USE_DIR: Unable to access directory contents."
	exit
fi

cd "$USE_DIR"

# Functions
user_wait() {
	echo -n "Press any key to continue..."
	read
}

error_ro() {
	echo "$0: $USE_DIR: Read-only directory."
	user_wait
}

read_num () {
	echo -n "Script number: "
	read num
	while [ -z "${use[num]}" ]; do
		[ -z "$num" ] && return 0
		echo "$0: Invalid number."
		echo -n "Script number: "
		read num
	done
	return 0
}

new_script () {
	if $writable; then
		echo -n "Name: "
		read name
		[ -z "$name" ] && return 0
		touch "$name"
		chmod +x "$name"
		$EDITOR "$name"
	else
		error_ro
	fi
}

delete_script () {
	if $writeable; then
		read_num
		rm "${use[num]}"
	else
		error_ro
	fi
}

edit_script () {
	read_num
	while [ ! -w "${use[num]}" ]; do
		echo "$0: ${use[num]}: Read-only file."
		read_num
	done
	$EDITOR "${use[num]}"
}
		

rename_script () {
	if $writeable; then
		read_num
		echo -n "New name: "
		read name
		[ -z "$name" ] && return 0
		mv "${use[num]}" "$name"
	else
		error_ro
	fi
}
		
show_script () {
	read_num
	$SHOW "${use[num]}"
}

		
# Menu
menu () {
	clear

	# Check write permission.
	if [ -w "$USE_DIR" ]; then
		writeable=true
	else
		echo "NOTE: Running in read-only mode."
		writeable=false
	fi

	# Get directory contents
	typeset -i cnt=0
	use[0]=""
	for f in *; do
		if [ -f "$f" -a -x "$f" ]; then
			cnt=cnt+1
			use[cnt]=$f
		fi
	done	

	# Start listing options
	if $writeable; then
		echo " n) New script"
		echo " d) Delete script"
		echo " r) Rename script"
	fi

	echo " e) Edit script"
	echo " s) Show script"

	for i in `seq $cnt`; do
		echo -n " $i) ${use[i]}"
		[ ! -w "${use[i]}" ] && echo -n " (read only)"
		echo
	done

	# Ask
	echo
	echo -n "Choose an option: "
	read opt

	case $opt in
	n|N) new_script ;;
	d|D) delete_script ;;
	e|E) edit_script ;;
	r|R) rename_script ;;
	s|S) show_script ;;
	*)
		if [ -n "${use[opt]}" ]; then
			"$USE_DIR/${use[opt]}"
			exit
		fi
	esac
}

while true; do
	menu
done
