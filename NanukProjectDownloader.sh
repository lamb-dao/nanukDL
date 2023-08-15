#!/bin/bash

echo "Begin: Nanuk Project Downloader"

#login info
echo "Enter your Nanuk username and password."
J_USER=""
J_PASS=""
read -p "User ID: " J_USER
read -p "Password: " -s J_PASS

echo -n "j_username=${J_USER}&j_password=${J_PASS}" > .auth.txt
chmod 600 .auth.txt

#User entry of project and tech
echo -e "\nEnter the project ID and technology type."
echo -e "\teg.\n\tEnter projectID as 22507\n\tEnter tech as NovaSeq"
echo ""
echo  "This information is found at Nanuk"
echo -e "==================================="
echo -e "Login to  https://ces.genomequebec.com/nanuqAdministration/"
echo -e "Open the project from the 'Project Data/Result' column"
echo -e "Select the 'Read Sets' tab"
echo -e "Click the 'Download Read Files' button"
echo -e "Select the 'Download all reads for the technology' button"
echo -e "Write down the 'projectId=' and 'tech=' information found in the code box."
echo -e "    Look for a section of text similar to"
echo -e "    'projectId=22507&tech=NovaSeq'"
echo -e "==================================="
echo ""

projectID=""
tech=""
read -p "projectID: " projectID
read -p "tech: " tech

#make unique recieving directory
projDir="./NanukDL${projectID}"
mkdir -p "${projDir}"

#complete Nanuk request string
getStr="https://ces.genomequebec.com/nanuqMPS/readsetList?projectId=${projectID}&tech=${tech}"




#download file list
wget \
    -O ${projDir}/fileList.txt \
    ${getStr} \
    --no-cookies \
    --no-check-certificate \
    --post-file .auth.txt \
    --output-file ${projDir}/fileListDL.log

#use file list to request files
cd ${projDir}

#capture full projDir path for reporting
target=$(pwd)

wget \
    --no-cookies \
    --no-check-certificate \
    --post-file ../.auth.txt \
    --continue \
    --show-progress \
    --input-file fileList.txt \
    --output-file filesDL.log

#remove auth file
cd ..
rm -f .auth.txt

#print completion message, instructions to get md5 and confirmation.
echo -e "The download script is at the end, check the fileDL.log file to ensure all files were recieved."
echo -e "Re-running the script will restart incomplete files and will not repeatfiles that are complete"
echo -e "When all files are fully downloaded, check file integrity with md5sum"
echo ""
echo -e "The checksum file must be downloaded separately from Nanuk"
echo -e "==================================="
echo -e "Login to  https://ces.genomequebec.com/nanuqAdministration/"
echo -e "Open the project from the 'Project Data/Result' column"
echo -e "Click the 'Read Sets' tab"
echo -e "Select all files; just below 'Filter' click the top checkbox"
echo -e "Click the 'Download Read Files' button"
echo -e "Select the 'Download files from selected reads' button"
echo -e "Select the 'Md5 File' button"
echo -e "Select the 'Fastq R1' and 'Fastq R2/R3' buttons"
echo -e "Click the 'Download' button"
echo -e "Move the 'readSets.md5' file to:\n\t${target}"
echo -e "==================================="

exit 0
