#!/bin/bash 

# This function checks that the user running the script is root
function CHECK_ROOT()
{
    USER=$(whoami)
    if [ $USER != "root" ]; then
        echo "You are not root .... Exiting...."
        figlet "NOT ROOT"
        sleep 1
        exit
    else
        echo "User is root! ... Proceeding....."
        figlet "ROOT"
        sleep 1
        CHECK_TOOLS
    fi
}

CHECK_ROOT