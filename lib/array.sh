# /usr/bin/env bash

array_join()  {
	local sep=$1
	shift

	
	local args=( "$@" )
	let idx=0
	let size=${#args}

	while (( $idx < $size )) 
	do
		if (( $idx == $size-1 ))
		then
			echo -n "$args[$idx]"
			return 0
		fi

		echo -n "$args[$idx]$sep"
	done
}

array_contains() { 
	for e in "${@:2}"
	do 
		if [[ "$e" == "$1" ]]
		then
			return 0;
		fi
	done 

	return 1
}

array_print() {
	echo -n "( "

	for e in "${@}"
	do 
		echo -n "$e "
	done 

	echo ")"
}

array_uniq() {
	(
		for e in "${@}"
		do 
			echo "$e"
		done 
	) | sort | uniq
}
