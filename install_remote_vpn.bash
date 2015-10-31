HOST="$1"
CLIENTNAME="$2"
USAGE="\nUsage:\n    ./install_remote_vpn <HOST> <CLIENTNAME>"

if [ -z "$HOST" ];
then 
	echo -e "\nMissing Host IP$USAGE\n"
	exit
fi

if [ -z "$CLIENTNAME" ];
then 
	CLIENTNAME="client"
fi

scp docker_ovpn.bash root@$HOST:/root/ &&
ssh -t root@$HOST "chmod +x /root/docker_ovpn.bash && /root/docker_ovpn.bash $CLIENTNAME" &&
scp root@$HOST:/root/$CLIENTNAME.ovpn /home/$USER/$CLIENTNAME.ovpn &&
echo -e "\nProfile saved to /home/$USER/$CLIENTNAME.ovpn\n"

