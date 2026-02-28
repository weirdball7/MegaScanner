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
    CHECK_TOOLS 
}

function CHECK_TOOLS()
{
    TOOLS=("nmap" "hydra" "medusa" "exploitdb")

    echo "Updating apt ..."
    sudo apt update 
    sudo apt upgrade -y 

    echo "Checking for tools ..."
    for ITEM in "${TOOLS[@]}"; do
        if [ "$ITEM" = "exploitdb" ]; then
            
            if ! command -v searchsploit >/dev/null; then
                echo "[*] searchsploit not found ... installing [*]"
                sleep 2
                sudo apt install "$ITEM" -y
            else
                echo "[*] searchsploit found! ... continuing....[*]"
                sleep 2
            fi
        else
            if ! command -v "$ITEM" >/dev/null; then
                echo "[*] $ITEM not found ... installing [*]"
                sleep 2
                sudo apt install "$ITEM" -y
            else
                echo "[*] $ITEM found! ... continuing....[*]"
                sleep 2
            fi
        fi
    done

    GET_IP
}   


CHECK_IP() {
  local ip="$1"

  # validate format
  if [[ ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    return 1
  fi

  # validate range 0-255
  local a b c d
  IFS='.' read -r a b c d <<< "$ip"
  for octet in "$a" "$b" "$c" "$d"; do
    # ensure it's a number and within range
    if [[ ! "$octet" =~ ^[0-9]+$ ]] || (( octet < 0 || octet > 255 )); then
      return 1
    fi
  done

  return 0
}

GET_IP() {
  while true; do
    echo "Please provide a network address to scan ..."
    read -r IP_ADDR

    if CHECK_IP "$IP_ADDR"; then
      echo "Target IP: $IP_ADDR"
      break
    else
      echo "Invalid IP address format, try again."
    fi
  done

  # אם אתה צריך לאפס סביבה - תעשה את זה פה אחרי שקיבלנו IP תקין
  RESET_DEV_ENVIORMENT
}


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