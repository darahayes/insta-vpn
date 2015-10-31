HOST="$1"
CLIENTNAME="$2"
USAGE="\nUsage:\n    ./create_client <HOST> <CLIENTNAME>"
OVPN_DATA="ovpn-data"

CREATE_CLIENT_KEY="docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENTNAME nopass"
CREATE_PROFILE="docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn"

if [ -z "$HOST" ];
then 
	echo -e "\nMissing Host IP$USAGE\n"
	exit
fi

if [ -z "$CLIENTNAME" ];
then 
	echo -e "\nMissing CLIENTNAME$USAGE\n"
	exit
fi

ssh -t root@$HOST "$CREATE_CLIENT_KEY && $CREATE_PROFILE" &&
scp root@$HOST:/root/$CLIENTNAME.ovpn /home/$USER/$CLIENTNAME.ovpn &&
echo -e "\nProfile saved to /home/$USER/$CLIENTNAME.ovpn\n"