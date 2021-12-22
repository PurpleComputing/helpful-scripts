
#                                                       ******      
#                                        *...../    /    ******               
# **************  *****/  *****/*****/***/*************/ ******  /**********      
# ******/..*****/ *****/  *****/********//******/ ,*****/******,*****  ,*****/    
# *****/    ***** *****/  *****/*****/    *****/   /**************************    
# *******//*****/ *************/*****/    *********************/*******./*/*  ())
# *************    ******/*****/*****/    *****/******/. ******   ********** (()))
# *****/                                  *****/                              ())
# *****/                                  *****/                                  
#

#//////////////////\\\\\\\\\\\\\\\\\\\\#
#\\\\\\\\\\\\\\\\\\////////////////////#
#//////////////////\\\\\\\\\\\\\\\\\\\\#
#\\\\\\\\\\\\\\\\\\////////////////////#
###\\\\ INCOMPLETE DUE NOT TEST  ////###
#//////////////////\\\\\\\\\\\\\\\\\\\\#
#\\\\\\\\\\\\\\\\\\////////////////////#
#//////////////////\\\\\\\\\\\\\\\\\\\\#
#\\\\\\\\\\\\\\\\\\////////////////////#


################################################################################################


# First get your NodeID (some OS require sudo here)
NETID=[REPLACE WITH NET ID]
#
APIKEY=[REPLACE WITH API KEY]
#
MYID=$(zerotier-cli info | cut -d " " -f 3)
DEVNAME=$(hostname -f)
DEVDESC=Device authorised through Purple Script.
#Then call the API
curl -H "Authorization: Bearer $APIKEY" -X POST -d '{"name":"$DEVNAME","description":"$DEVDESC","config":{"authorized":true}}' https://my.zerotier.com/api/network/$NETID/member/$MYID
curl -s -H "Authorization: Bearer $APIKEY" https://my.zerotier.com/api/network/$NETID/member/$MYID >> '~/.config.authorized'
