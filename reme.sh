#!/bin/bash

function binwalk {
  echo -e "\e[3m Starting Binwalk...\e[0m"
  read -n1 -p "Would you like to output the results to a file? [y/n]" doit
  case $doit in
      y|Y) echo -e "\n\e[3m Enter FULL pathway of target file...\e[0m"
        read pathway
        echo -e "\e[3m Enter name of file you would like the output to be in...\e[0m"
        read filename
          if [[ -a "${pathway}" ]]; then #checking existence of file
            /usr/bin/binwalk --log=${filename}.txt ${pathway}
          else
            echo "Unable to locate"
            echo "Try again."
          fi ;;
      n|N) echo -e "\n\e[3m Enter FULL pathway of target file...\e[0m"
        read pathway
        if [[ -a "${pathway}" ]]; then #checking existence of file
          /usr/bin/binwalk ${pathway}
        else
          echo "Unable to locate"
          echo "Try again."
        fi;;
  esac
}

function REME {
  echo -e "\e[3m Starting Reverse Engineering Made Easy...\e[0m"
  echo -e "\n\e[3m Enter FULL pathway of target file...\e[0m"
  read pathway
    if [[ -a "${pathway}" ]]; then #checking existence of file
      if [[ $(/usr/bin/binwalk ${pathway} | grep 'Squashfs') = *Squashfs* ]]; then
        echo -e "\e[3m Enter name of file you would like the output to be in...\e[0m"
        read outputfile
        /usr/bin/binwalk --log=${outputfile}.txt ${pathway}
        clear
        cat ${outputfile}.txt | grep -i 'Squashfs' | awk 'NR==1{print "Address found!: " $(1) "\n","Filesystem Found!: " $(3) "\n","Compresion method found!: " $(9) "\n" "Next suggested command is: dd if=YOUR_FILE " "bs=1 skip=" $1 " of=YOUR_FILE"}'
        read -n1 -p "Please take note of these values then press Y to continue of N to exit the process [y/n]" ddsection
        case $ddsection in
          y|Y) echo -e "\n\e[3m Enter the name you would like for the binary file that is output...\e[0m"
            read binaryname
            echo -e "\n\e[3m Enter the address value...\e[0m"
            read addressvalue
            dd if=${pathway} bs=1 skip=${addressvalue} of=${binaryname}.bin
            echo -e "\n\e[3m Process successful!\e[0m"
            echo -e "\n\e[3m Next suggested command is: unsquashfs ${binaryname}.bin\e[0m"
            read -n1 -p "Do you wish to continue? [y/n]" unsquashsection
            case $unsquashsection in
              y|Y) unsquashfs ${binaryname}.bin
              echo -e "\n\e[3m Task complete\e[0m"
              echo -e "\n\e[3m To view the contents of the filesystem simply close this tool and cd into the directory\e[0m"
            esac
        esac
      fi
    fi
}

function menu {
  clear
  /usr/bin/figlet -f digital -c REME
cat << "EOF"
    .-.                                                               .-.
   /   \           .-.                                 .-.           /   \
  /     \         /   \       .-.     _     .-.       /   \         /     \
-/-------\-------/-----\-----/---\---/-\---/---\-----/-----\-------/-------\--
          \     /       \   /     `-'   `-'     \   /       \     /
           \   /         `-'                     `-'         \   /
            `-'                                               `-'
EOF
  echo -e "\t\t\tReverse Engineering Made Easy\n"
  echo -e "\t\t\t1. binwalk"
  echo -e "\t\t\t2. REME"
  echo -e "\t\t\t0. Exit\n\n"
  echo -en "\t\t\tEnter option: \n"
  read -n 1 option
}

while [ 1 ]
do
  menu
  case $option in
    0)
      break ;;
    1)
      binwalk ;;
    2)
      REME ;;
    *)
      clear
      echo "Not available.";;
    esac
    echo -en "\n\n\t\t\tHit any key to continue"
    read -n 1 line
done
clear
$
