
#!/bin/bash
#This script fetches the current block height several from Lisk nodes and display the current block on the node
#Nodes thean are compared to determine if one is behind.  A log or alert can be generated.
#requires jq for parsing the jsan output from the nodes - sudo apt-get install jq
clear
echo ""

tput sc
while true
do
        #Fetch block height from several nodes and parse
        #enter the ip address or url of monitored nodes in xxx.xxx.xxx.xxx below.
        node1=$(curl -i -H "Accept: application/json" http://xxx.xxx.xxx.xxx:7000/api/blocks/getHeight 2>&1 | grep "height" | jq '.height')
        node2=$(curl -i -H "Accept: application/json" http://xxx.xxx.xxx.xxx:7000/api/blocks/getHeight 2>&1 | grep "height" | jq '.height')
        liskio=$(curl -i -H "Accept: application/json" http://login.lisk.io:7000/api/blocks/getHeight 2>&1 | grep "height" | jq '.height')
        
        #display the data
        tput rc
        tput ed 
        echo -en "node1: " "\e[1;33m$node1\e[0m"  "  node2: " "\e[1;33m$node2\e[0m"  "  lisk.io: " "\e[1;33m$liskio\e[0m"

        #compare nodes and display and log when one falls behind the other
        if (( "$node2" < "$liskio-1" )); then 
         echo ""        
         echo -e "\e[1;33m*** node2 is behind by $((liskio-$node2))\e[0m *** $(date)"
         echo -e "\e[1;33m*** node2 is behind by $((liskio-$node2))\e[0m *** $(date)" >> Lisk.log
        fi

        if (( "$node1" < "$liskio-1" )); then 
         echo "" 
         echo -e "\e[1;33m*** node1 is behind by $((liskio-$node1))\e[0m *** $(date)"
         echo -e "\e[1;33m*** node1 is behind by $((liskio-$node1))\e[0m *** $(date)" >> Lisk.log
        fi

        sleep 10
done

