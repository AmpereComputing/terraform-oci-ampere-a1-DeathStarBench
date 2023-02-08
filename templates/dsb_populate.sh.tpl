#!/usr/bin/env bash
set -x
exec &>> $HOME/dsb_populate.log
COMPLETED=$(kubectl get pods -n social-network | grep Completed | wc -l)
until [ $COMPLETED -eq 3 ]
do 
  COMPLETED=$(kubectl get pods -n social-network | grep Completed | wc -l)
  echo "COMPLETED: " $COMPLETED
  sleep 60
done
cd /home/ubuntu/DeathStarBench/socialNetwork
python3 scripts/init_social_graph.py --graph=socfb-Reed98 --ip=${dsb_private_ip} --port=32080
