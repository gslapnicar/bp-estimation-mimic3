#!/bin/bash

function run_category {
	# Open file with list of all records.
    fs=`wfdbcat mimic3wdb/$1/RECORDS`
    # Append records to file Fs.txt
    echo $fs >> Fs.txt

    touch "out$1.txt"

    # For each record in records
    for F in $fs
    do
    	# Open inner RECORDS file
        in=$1/$F
        s=`wfdbcat mimic3wdb/$in/RECORDS`
        echo $s >> Rs.txt

        # For each record
        for R in $s
        do
        	echo "$in" >> out.txt
            printf "\r%-25s\t\t" "$R"

			# If not already processed (if filename is not in out$1.txt)
            if [ `grep $R out$1.txt -c` -lt 1 ]
            then
            	# Convert record to .mat file
            	# -r convert record - current filename
            	# -s convert only signals PLETH ABP
            	# Write output to .info file
            	success="$(wfdb2mat -r mimic3wdb/$in$R -s PLETH ABP 2>&1 > data/$R.info)"

                if [ "${#success}" -lt 1 ]
                then
                    printf "\r%-25s\t\tOK\n" "$R"
                else
                    # printf "\r$R\t\t$success\n"
                    rm data/$R.info
                fi

                mv $R* data 2> /dev/null

                # Add filename to out$1.txt
	            echo "$R" >> out$1.txt
            fi

        done
    done

    echo "$1 finished" >> fins.txt
    printf "\r\t\t\t\t\n"
}

echo "Started"
# For each folder from 30, 31, 32, .. 39
for i in {0..9}
do
    run_category 3$i &
done

wait
