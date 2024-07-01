#!/bin/bash

# Number of times to run the command
n=20

# File to store the average values of all runs
output_file="output_diff.txt"

bench_file="bench_orig.txt"
temp_file="temp_diff.txt"

# Ensure the output file is empty before starting
> "$output_file"

# Function to calculate the average of "Difference" lines
calculate_difference_avg() {
    sum=0
    count=0

    # Read the file line by line
    while IFS= read -r line
    do
        # Check if the line contains a "Difference" with tab and spaces
        if [[ $line =~ ^Difference:\ ([0-9]+)[[:space:]]*$ ]]; then
            value=${BASH_REMATCH[1]}
            sum=$((sum + value))
            count=$((count + 1))
        fi
    done < "$1"

    # Calculate the average using awk for floating-point division
    if [ $count -ne 0 ]; then
        avg=$(awk "BEGIN {print $sum / $count}")
    else
        avg=0
    fi

    echo "Difference $avg"
}

# Run the command n times and collect the average values
for ((i=1; i<=n; i++))
do
    echo "Running attempt $i of $n..."
    ./build/p3923/bench/verif verif.tsv > "$bench_file"
    # Extract the last line and append it to the output file
    last_avg_line=$(tail -n 1 "$bench_file")
    echo "$last_avg_line" >> "$output_file"

    # Calculate the difference average and append it to the output file
    calculate_difference_avg "$bench_file" >> "$output_file"

    echo "Attempt $i finished successfully."
done

# Debug output to verify the file content
cat "$output_file"

# timestamp=$(date +%Y%m%d%H%M%S)
# output_file="${output_base}_${timestamp}.txt"

# this file will store the averages 
summary_file="summary_file.txt"

# Compute the overall averages from the collected average values in the output file
awk '
    /^Avg/ {
        sum1 += $2;
        gsub(/\./, "", $3); # Remove dots for easier summing
        sum2 += $3;
        count++;
    }
    /^Difference/ {
        sum_diff += $2;
        count_diff++;
    }
    END {
        avg1 = sum1 / count;
        avg2 = sum2 / count / 1000; # Adjust for dot removal
        avg_diff = sum_diff / count_diff;
        print "Overall Avg\t" avg1 "\t" avg2 > "'"$summary_file"'";
        print "Overall Difference\t" avg_diff >> "'"$summary_file"'";
    }
' "$output_file"
