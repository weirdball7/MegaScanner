#!/bin/bash 
IP_ADDR=""
OUTPUT_DIR=""
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
            OUTPUT_DIR="$HOME/MegaScannerOutput"
            mkdir -p "$OUTPUT_DIR"
            cd "$OUTPUT_DIR"
            echo "Output directory created in $(pwd)"
            sleep 1
            ;;
        "2")
            echo "Please provide a path for output directory."
            read USER_PATH
            OUTPUT_DIR="$USER_PATH/MegaScannerOutput"
            mkdir -p "$OUTPUT_DIR"
            cd "$OUTPUT_DIR"
            echo "Output directory created in $(pwd)"
            ;;
        *) 
          echo "Invalid option."
          CREATE_OUT_DIR
          ;;
    esac
    # CHECK_TOOLS 
    GET_IP
}

# function CHECK_TOOLS()
# {

# }

function GET_IP() 
{
  echo "Please provide a network address to scan ..."
  read -r IP_ADDR
  echo "Target IP: $IP_ADDR"
#   CHECK_IP
    RESET_DEV_ENVIORMENT
}

# function CHECK_IP() 
# {

# }


function RESET_DEV_ENVIORMENT()
{
    echo "Do u want to reset development enviorment? (THIS WILL DELETE ANY OUTPUT CREATED BY THE SCRIPT)"
    read CHOICE 
    case $CHOICE in   
    "y") 
       echo "DELETING ALL PROJECT OUTPUT"
       if [ -n "$OUTPUT_DIR" ]; then
           cd "$OUTPUT_DIR/.." 2>/dev/null || cd /
           sudo rm -rf "$OUTPUT_DIR"
           echo "Complete!"
       else
           echo "No output directory recorded; nothing deleted."
       fi
       exit
       ;;
    "n")
       echo "Exiting..."
       exit
       ;;
    *)
      echo "Invalid Input"
      RESET_DEV_ENVIORMENT
      ;;
    
    esac 
}



CHECK_ROOT