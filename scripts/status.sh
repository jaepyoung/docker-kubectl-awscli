#!/bin/bash

app=$1
namespace=${2:-default}

if [ -z "$app" ] || [ -z "$namespace" ]; then
    echo -e "\nPlease specify the App name and the namespace (default if empty)!\n";
    exit 1;
else
    # Get the timeout from the deployment and divide into 10 seconds spaced chunks
    declare -i x=$(( `kubectl get deployment $app -o=jsonpath='{.spec.progressDeadlineSeconds}' --namespace=$namespace`/10 ))
    echo "Setting timeout: $x runs"
    i=0
    while [ $i -le $x ]
    do
        status=`kubectl rollout status deploy/$app --namespace=$namespace --watch=false 2>&1`
        if [ $i -eq $x ]; then
            echo $status;
            echo "Exiting due to timeout. The deployment for $app has probably failed!"
            exit 1;
        elif [[ $status == *"successfull"* ]]; then
            echo $status;
            exit 0;
        elif [[ $status  == *"Waiting"* ]]; then
            echo $status;
            ((i++));
        elif [ $? -eq 1 ]; then
            echo $status;
            exit 1;
        fi
        sleep 10;
    done
fi

