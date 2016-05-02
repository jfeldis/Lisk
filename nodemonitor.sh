
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
        neon=$(curl -i -H "Accept: application/json" http://192.168.1.144:7000/api/blocks/getHeight 2>&1 | grep "height" | jq '.height')
        bitseed=$(curl -i -H "Accept: application/json" http://142.4.216.224:7000/api/blocks/getHeight 2>&1 | grep "height" | jq '.height')
        liskio=$(curl -i -H "Accept: application/json" http://login.lisk.io:7000/api/blocks/getHeight 2>&1 | grep "height" | jq '.height')
        
        #display the data
        tput rc
        tput ed 
        echo -en "Neon: " "\e[1;33m$neon\e[0m"  "  Bitseed: " "\e[1;33m$bitseed\e[0m"  "  lisk.io: " "\e[1;33m$neon\e[0m"

        #compare nodes and display and log when one falls behind the other
        if (( "$bitseed" < "$liskio-1" )); then 
         echo ""        
         echo -e "\e[1;33m*** Bitseed is behind by $((liskio-$bitseed))\e[0m *** $(date)"
         echo -e "\e[1;33m*** Bitseed is behind by $((liskio-$bitseed))\e[0m *** $(date)" >> Lisk.log
        fi

        if (( "$neon" < "$liskio-1" )); then 
         echo "" 
         echo -e "\e[1;33m*** Neon is behind by $((liskio-$bitseed))\e[0m *** $(date)"
         echo -e "\e[1;33m*** Neon is behind by $((liskio-$bitseed))\e[0m *** $(date)" >> Lisk.log
        fi

        sleep 10
done

