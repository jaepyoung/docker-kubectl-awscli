#!/bin/bash

set -eou pipefail

app=$1
namespace=${2:-default}

echo "Checking app and namespace are set"

if [ -z "$app" ] || [ -z "$namespace" ]; then
    echo -e "\nPlease specify the App name and the namespace (default if empty)!\n";
    exit 1;
else
    set +e
    status=$(kubectl rollout status deploy/$app --namespace=$namespace --watch=false 2>&1)
    set -e
    
    code=$?;
    i=0;
    while [[ "${code}" == 0 && "${status}" != *"successful"* ]]
    do
        echo "checking rollout status [${i}]";
        i=$((i + 1));
        set +e
        status=$(kubectl rollout status deploy/$app --namespace=$namespace --watch=false 2>&1)
        code=$?;
        set -e
        sleep 10;
    done
    
    echo "${status}";
fi

