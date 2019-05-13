#!/bin/bash
echo Cleaning...

if [ ${1:-1} -eq 0 ] # If first argument (if not defined set it to -1) is equal to 0.
then
	# Delete all cle* and dat* files
	find . ! \( -name "data/cle*" -or -name "data/Dat*" \) -delete
else
	# Delete empty files.
    echo "Deleting empty files."
	find data/ -size 0 -delete

	# Find .mat files with size less than 280 512-bit blocks -> less than 17kB
    echo "Searching for small files."
    s=`find data/ -size -280 -name "*.mat"`
	# Create array from s, split on spaces
	array=(${s// /})

	for e in "${array[@]}"  # For all elements in array.
	do
		l=${#e}  # length of element
		let "l=$l-3" # Ignore last 3 characters
		rm ${e:0:$l}* # Remove mat and hea files
        let "l=$l-2"  # l -= 7
        rm ${e:0:$l}.info # Remove .info file

        echo "Removed $e"
	done
fi
