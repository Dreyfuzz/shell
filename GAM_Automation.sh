#! /bin/bash

gam="python /gam/gam.py" #set this to the location of your GAM binaries
DATE=`date +%Y-%m-%d`
newuser(){
   echo "    Patch gApps Admin"
   read -p "Enter email address to admin: " email
   }
clear
newuser
while :
do
 clear
 echo "Currently Managing $email"
 echo "   M A I N - M E N U"
 echo "1. Set Vacation Message /Remove Forward"
 echo "2. Delete Signature"
 echo "3. Check Vacation Message"
 echo "4. Remove From All Groups"
 echo "5. Check Group Membership"
 echo "6. Perform All Tasks"
 echo "7. Mirror $email's Groups to another user"
 echo "8. Admin Another User"
 echo "9. Exit"
 echo "Please enter option [1 - 9]"
    read opt
    case $opt in
     1) echo "************ Set Vacation Message / Remove Forward *************";
        read -p "Please enter vacation message: " vaca_message
        read -p "Enter vacation message end date YYYY-MM-DD: " end_date
        $gam user $email forward off
        $gam user $email vacation on subject 'Out of the office' message "$vaca_message" startdate $DATE enddate $end_date
        echo "Press [enter] key to continue. . .";
        read enterKey;;
     2) echo "************ Delete Signature ************";
        $gam user $email signature ' ';
        echo "Press [enter] key to continue. . .";
        read enterKey;;
     3) echo "************ Current Vacation Message ************";
        $gam  user $email show vacation;
        echo "Press [enter] key to continue. . .";
        read enterKey;;
     4) echo "************ Remove From All Groups ************";
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
           for i in $purge_groups
            do
               echo removing $i |$gam update group $i remove member $email
            done;
        echo "All groups removed press [enter] key to continue. . .";
        read enterKey;;
     5) echo "************ Check Group Membership ************";
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1)
        echo $purge_groups;
        echo "Groups have been checked [enter] key to continue. . .";
        read enterKey;; 
     6) echo "************ Perform All Tasks ************";   
        read -p "Please enter vacation message: " vaca_message
        read -p "Enter vacation message end date YYYY-MM-DD: " end_date
        $gam user $email forward off
        $gam user $email vacation on subject 'Out of the office' message "$vaca_message" startdate $DATE enddate $end_date
        $gam user $email signature ' ';
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
           for i in $purge_groups
            do
               echo removing $i |$gam update group $i remove member $email
            done;
        echo "All tasks preformed press [enter] key to continue. . .";
        read enterKey;;
      
     7) echo "************ Mirror $email groups to another user ************";
        read -p  "Enter email address to be mirrored: " mirrored;
        echo $email groups will be mirrored to $mirrored press enter if this is OK?;
        read enterKey;
         purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
           for i in $purge_groups
            do
               echo adding $mirror to $i group  |$gam update group $i add member $mirrored
            done;
        echo "All groups have been mirrored press [enter] key to continue. . .";
        read enterKey;;
     8) echo "************ Admin Another User ************";
        newuser;       
        echo "Press [enter] key to continue. . .";
        read enterKey;;
     9) echo "Bye $USER";
        exit 1;; 
     *) echo "$opt is an invaild option. Please select option between 1-9 only"
       echo "Press [enter] key to continue. . .";
        read enterKey;;
esac
done
