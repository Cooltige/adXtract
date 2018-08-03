#!/bin/bash
printf "\33c"

if [ -z $3 ]; then

        echo '[!] Usage: ntds.dit SYSTEM ProjectName';
        echo '[!] Use full paths (not relative) for NTDS and SYSTEM files';

        exit 1;

fi

CWD="$(pwd)"
NTDS=$1
SYSFILE=$2
PROJECT=$3

echo '[-] Working dir: ' $CWD

mkdir $CWD'/projects_'$PROJECT
mkdir $CWD'/projects_'$PROJECT'/Maps'

cd resources/libesedb-20160622/esedbtools

echo '[-] Extracting tables'
./esedbexport -t $CWD/projects_$PROJECT/$PROJECT $NTDS > $CWD/projects_$PROJECT/exported.log

cd $CWD 
echo "[-] Moved to dir: "$CWD

cd resources/ntdsxtract2/

echo "[-] Extracting LM and NTLM hashes"
./dsusers.py $CWD/projects_$PROJECT/$PROJECT.export/datatable* $CWD/projects_$PROJECT/$PROJECT.export/link_table* $CWD/projects_$PROJECT/Maps/ --passwordhashes --pwdformat ophc --passwordhistory --syshive $SYSFILE --lmoutfile $CWD/projects_$PROJECT/$PROJECT_allLMhashes.txt --ntoutfile $CWD/projects_$PROJECT/$PROJECT_allNTLMhashes.txt --csvoutfile $CWD/projects_$PROJECT/$PROJECT_UserAccountOut.csv

echo "[-] Extracting Group Membership information"
./dsgroups.py $CWD/projects_$PROJECT/$PROJECT.export/datatable* $CWD/projects_$PROJECT/$PROJECT.export/link_table* $CWD/projects_$PROJECT/Maps/ --members --csvoutfile $CWD/projects_$PROJECT/$PROJECT_GroupMembershipOut.csv

echo "[+] Completed: "
echo "  LM Hashes        : $CWD/projects_"$PROJECT"/"$PROJECT"_allLMhashes.txt"
echo "  NTLM Hashes      : $CWD/projects_"$PROJECT"/"$PROJECT"_allNTLMhashes.txt"
echo "  User Accounts    : $CWD/projects_"$PROJECT"/"$PROJECT"_UserAccountOut.csv"
echo "  Group Membership : $CWD/projects_"$PROJECT"/"$PROJECT"_GroupMembershipOut.csv"
