#!/bin/sh

# jssUser is the JAMF user with API permissions and can be supplied using Parameter 4
jssUser=$4

# jssPass is the password of the JAMF user with API permissions and can be supplied using Parameter 5
jssPass=$5

# jssHost is the url of the JAMF instance and can be supplied using Parameter 6
jssHost=$6

# Get the serial number of the Mac that the script is running on
SERIAL=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')

# Contact the JSS and look up the user information for the Mac's serial number
USERINFO=$(curl -k ${jssHost}/JSSResource/computers/serialnumber/${SERIAL}/subset/location -H "Accept: application/xml" --user "${jssUser}:${jssPass}")

# Extract the Email Address from the returned user information
EMAILADDRESS=$(echo $USERINFO | /usr/bin/awk -F'<email_address>|</email_address>' '{print $2}' | tr [A-Z] [a-z])

# Extract the users full name from the returned user information
FULLNAME=$(echo $USERINFO | /usr/bin/awk -F'<realname>|</realname>' '{print $2}')

# Extract the users first name from the returned user information by splitting the realname
FIRSTNAME=$(echo $USERINFO | /usr/bin/awk -F'<realname>|</realname>' '{print $2}'|cut -f1 -d" ")

# Extract the users last name from the returned user information by splitting the realname
LASTNAME=$(echo $USERINFO | /usr/bin/awk -F'<realname>|</realname>' '{print $2}'|cut -f2 -d" ")

# Extract the users position from the returned user information
# POSITION=$(echo $USERINFO | /usr/bin/awk -F'<position>|</position>' '{print $2}')

# Extract the users phone from the returned user information
# PHONE=$(echo $USERINFO | /usr/bin/awk -F'<phone>|</phone>' '{print $2}')

# Extract the users department from the returned user information
# DEPARTMENT=$(echo $USERINFO | /usr/bin/awk -F'<department>|</department>' '{print $2}')

# Extract the users building from the returned user information
# BUILDING=$(echo $USERINFO | /usr/bin/awk -F'<building>|</building>' '{print $2}')

# Extract the users room from the returned user information
# ROOM=$(echo $USERINFO | /usr/bin/awk -F'<room>|</room>' '{print $2}')