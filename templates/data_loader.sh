#!/usr/bin/env bash
COMPLETED=$(kubectl get pods -n social-network | grep Completed | wc -l)
RUNNING=$(kubectl get pods -n social-network | grep Running | wc -l)
# Begin Waiting for COMPLETED to get to 3
echo "**** Waiting for COMPLETED to get to 3      ****"
until [ "$COMPLETED" -eq 3 ]
do 
  COMPLETED=$(kubectl get pods -n social-network | grep Completed | wc -l)
  echo "$COMPLETED"
  RUNNING=$(kubectl get pods -n social-network | grep Running | wc -l)
  echo "$RUNNING"
done
echo "**** "$COMPLETED equals 3 ***********************"

echo "**** Waiting for RUNNING to get to 3      ****"
until [ "$RUNNING" -eq 35 ]
do 
  RUNNING=$(kubectl get pods -n social-network | grep Running | wc -l)
  echo "$RUNNING"
done
echo "**** "$RUNNING equals 35 ***********************"
