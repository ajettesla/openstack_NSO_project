#!/bin/bash

openrc_file=$1
tag=$2
sshkey=$3

export image_name='Ubuntu 22.04 Jammy Jellyfish x86_64'
export flavor_name='m1.small'

if [[ "$testing" == "0" ]]; then
    ## Use for Data collection
    echo "Real Data Collection"
    CONCURRENCY=60
    REPEAT=32
else
    ## Use for _TESTING__
    echo "**TESTING only**"
    CONCURRENCY=5
    REPEAT=10
fi

floatingIP="your_floating_ip_here"

./operate.sh openrc_file test key1.pem 0 > /dev/null 2>&1 &

nodes=5

echo "Concurrency = $CONCURRENCY, REPETITIONS = $REPEAT"

## Remove any performance data files.
rm -rf perf_*.txt

for ((i=1; i <= ${nodes}; i++)); do 
  echo $i > server.conf
  echo "sleep for 30 sec"
  sleep 30
  for ((j=1; j<=CONCURRENCY; j++)); do
    for ((k=1; k<=REPEAT; k++)); do
	    bonkers=$(ab -n 10000 -c $j ${floatingIP} 2>/dev/null | grep 'Requests per second')
	    value=$(echo "$bonkers" | awk '{print $4}')
	    echo "C=$j, $k => $value"
	    if [[ -z "$value" ]]; then
	        echo "ERROR: No useful data was collected from AB, this is a serious ISSUE."
	        echo "ERROR: Check server on ${floatingIP}"
	        exit 1
	    fi
    
	    echo "$value" >> "perf_$j.txt"
    done
    echo "Done all repetitions for $j, doing statistics (with awk)."
    statistics=$(awk '{for(i=1;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2}} 
          END {for (i=1;i<=NF;i++) { 
          printf "%f %f \n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR)}
         }' perf_$j.txt)
    echo "$j => $statistics " | tee -a statistics${i}.log
  done

done

echo "*** Performance threaded server."
echo " "

gnuplot dcollect.p
