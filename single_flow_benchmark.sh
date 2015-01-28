# file_cnt test_cnt

src="172.16.0.24"
dest="172.16.16.32"

of_src="172.15.0.24"
of_dest="172.15.16.32"
port=6789

recvout="sdn_bench.recv.$1"
sendout="sdn_bench.send.$1"
dir="~/udp-benchmark"

# start tcpdump on switches
# tcpdump

# start of-server
ssh $dest "cd $dir; screen -d -m ./of-server $of_dest $port $recvout";

# start of-client
ssh $src "cd $dir; screen -d -m ./of-client $of_dest $port $sendout";

echo "SDN benchmarking...";
sleep 10;

# get output files
scp $dest:$dir/$recvout .;
scp $src:$dir/$sendout .;

# verify packet sequences on both ends
cut -d' ' -f1 $recvout > sdn_benchmark.tmp1;
cut -d' ' -f1 $sendout > sdn_benchmark.tmp2;
diff sdn_benchmark.tmp1 sdn_benchmark.tmp2;

# get timestamps on both ends
cut -d' ' -f4 $recvout > sdn_benchmark.tmp1;
cut -d' ' -f4 $sendout > sdn_benchmark.tmp2;

# get pkt_in overhead
t_con=0;
t_non=0;
for ((i=1; i<=$2; i=i+1))
do
     t1=$(cat sdn_benchmark.tmp1 | head -n$i | tail -n1);
     t2=$(cat sdn_benchmark.tmp2 | head -n$i | tail -n1);
     if [ $i -eq 1 ]; then
        t_con=$(echo "scale=6; $t1 - $t2" | bc);
     else
        t_non=$(echo "scale=6; $t_non + $t1 - $t2" | bc);
     fi
done

t_non=$(echo "scale=7; $t_non / $(($2 - 1))" | bc);
echo "scale=6; $t_con - $t_non" | bc;

rm sdn_benchmark.tmp*;
