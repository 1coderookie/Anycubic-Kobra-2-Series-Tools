#!/bin/bash

# global definitions:
RED='\033[0;31m'
NC='\033[0m'

# check the parameters
if [ $# != 2 ]; then
  echo "usage : $0 <project_root> <uart_package>"
  exit 1
fi

project_root="$1"
uart_package=$(echo "$2" | sed -e 's/^"//' -e 's/"$//')

# check the required tools
TOOL_LIST=("unzip")
i=0
part_num=${#TOOL_LIST[*]}
while [ $i -lt $((part_num)) ]; do
  echo "Checking tool: ${TOOL_LIST[$i]}"
  t=$(which "${TOOL_LIST[$i]}")
  if [ -z "$t" ]; then
    if [ ! -f "TOOLS/${TOOL_LIST[$i]}" ]; then
      echo -e "${RED}ERROR: Missing tool '${TOOL_LIST[$i]}' ${NC}"
      exit 2
    fi
  fi
  i=$(($i + 1))
done

# check the project root folder
if [ ! -d "$project_root" ]; then
  echo -e "${RED}ERROR: Cannot find the folder '$project_root' ${NC}"
  exit 3
fi

# check the uart package folder
uart_package_folder="${project_root}/RESOURCES/OPTIONS/uart/${uart_package}"
if [ ! -d "$uart_package_folder" ]; then
  echo -e "${RED}ERROR: Cannot find the folder '$uart_package_folder' ${NC}"
  exit 4
fi

# check the uart package file
uart_package_file="${uart_package_folder}/uboot.zip"
if [ ! -f "$uart_package_file" ]; then
  echo -e "${RED}ERROR: Cannot find the file '$uart_package_file' ${NC}"
  exit 5
fi

# check the target folder
target_folder="$project_root/unpacked"
if [ ! -d "$target_folder" ]; then
  echo -e "${RED}ERROR: Cannot find the target folder '$target_folder' ${NC}"
  exit 6
fi

# enable the selected ssh package
current_folder="$PWD"
cd "$target_folder" || exit 7
unzip -o "$uart_package_file"
cd "$current_folder" || exit 8

exit 0