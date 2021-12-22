
#                                                        ******      
#                                        *...../    /    ******               
# **************  *****/  *****/*****/***/*************/ ******  /**********      
# ******/..*****/ *****/  *****/********//******/ ,*****/******,*****  ,*****/    
# *****/    ***** *****/  *****/*****/    *****/   /**************************    
# *******//*****/ *************/*****/    *********************/*******./*/*  ())
# *************    ******/*****/*****/    *****/******/. ******   ********** (()))
# *****/                                  *****/                              ())
# *****/                                  *****/                                  
#
# MAC SPECIFIC SCRIPT
#
#//////////////////\\\\\\\\\\\\\\\\\\\\#
#\\\\\\\\\\\\\\\\\\////////////////////#
#//////////////////\\\\\\\\\\\\\\\\\\\\#
#\\\\\\\\\\\\\\\\\\////////////////////#
###\\\\  INCOMPLETE DO NOT TEST  ////###
#//////////////////\\\\\\\\\\\\\\\\\\\\#
#\\\\\\\\\\\\\\\\\\////////////////////#
#//////////////////\\\\\\\\\\\\\\\\\\\\#
#\\\\\\\\\\\\\\\\\\////////////////////#
#
#
################################################################################################
#
#    SET INFO
#
NETID=[REPLACE WITH NET ID]
APIKEY=[REPLACE WITH API KEY]
#
#
#
MYID=$(zerotier-cli info | cut -d " " -f 3)
DEVNAME=$(/usr/sbin/scutil --get ComputerName)
DEVDESC="Device authorised through Purple Script."
#
#    CALL API WITH INFO
#
curl -H "Authorization: Bearer $APIKEY" -X POST -d '{"name":"$DEVNAME","description":"$DEVDESC","config":{"authorized":true}}' https://my.zerotier.com/api/network/$NETID/member/$MYID
curl -s -H "Authorization: Bearer $APIKEY" https://my.zerotier.com/api/network/$NETID/member/$MYID >> '~/.ztconfig.authorized'
#
