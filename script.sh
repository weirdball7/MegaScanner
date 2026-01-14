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
        CREATE_OUT_DIR
    fi
}

function CREATE_OUT_DIR()
{
    echo "Please choose the option you prefer..."
    echo "(1) Create the output directory in the current path."
    echo "(2) Create the output directory in a path i choose."
    read CHOICE
    case $CHOICE in 
        "1")
            HOME=$(pwd)
            mkdir "$HOME/MegaScannerOutput"
            echo "Output directory created in $HOME/MegaScannerOutput"
            sleep 1
            ;;
        "2")
            echo "Please provide a path for output directory."
            read PATH
            mkdir "$PATH/MegaScannerOutput"
            echo "Output directory created in $PATH/MegaScannerOutput"
            sleep 1
            ;;
        *) 
          echo "Invalid option."
          CREATE_OUT_DIR
          ;;
    esac
    CHECK_TOOLS
}

CHECK_ROOT