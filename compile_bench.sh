#!/bin/bash

# Number of times to run the command
n=10

# File to store the average values of all runs
output_file="output.txt"
bench_file="bench_orig.txt"

# Ensure the output file is empty before starting
> "$output_file"

# Compile and check the program
if make && make check && make bench_verif; then
    echo "Compilation and initial run successful. Starting benchmarking loop..."

    # Run the command n times and collect the average values
    for ((i=1; i<=n; i++))
    do
	echo "Running attempt $i of $n..."
        ./build/p3923/bench/verif verif.tsv > "$bench_file"
        # Extract the last line and append it to the output file
        echo "Attempt $i finished successfully."
	tail -n 1 "$bench_file" >> "$output_file"
    done

    # Compute the average of the collected average values
    # Extract the second and third columns and compute their average
    awk '
    {  gsub(/\./, ",", $3);  # Replace dots with commas in the third column
        sum1 += $2;
        sum2 += $3;
        count++;
    }
    END {
        avg1 = int(sum1 / count + 0.5);  # Round to the nearest integer
        avg2 = sum2 / count;
        print "Overall Average\t" avg1 "\t" avg2 >> FILENAME;
    }' "$output_file"

else
    echo "Compilation or initial run failed. Exiting script."
    exit 1
fi
