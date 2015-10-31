CLIENTNAME="$1"

if [ -z "$CLIENTNAME" ];
then 
	CLIENTNAME="client"
fi

#Name of openvpn data container
export OVPN_DATA=ovpn-data

#get ip address of machine
IP_ADDR=`ip route get 8.8.8.8 | awk 'NR==1 {print $NF}'`

#config to be inserted into an init file
DOCKER_INIT="description \"Docker container for OpenVPN server\"\nstart on filesystem and started docker\nstop on runlevel [!2345]\nrespawn\nscript\n  exec docker run --volumes-from ovpn-data --rm -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn\nend script"


# Install Docker
curl -L https://get.docker.com/gpg | sudo apt-key add -
echo deb http://get.docker.io/ubuntu docker main | sudo tee /etc/apt/sources.list.d/docker.list
apt-get update && sudo apt-get install -y lxc-docker

#create data container
docker run --name $OVPN_DATA -v /etc/openvpn busybox
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_genconfig -u udp://$IP_ADDR:1194

#Generate the server's key infrastructure
docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn ovpn_initpki

# Create the docker-openvpn init script 
echo -e $DOCKER_INIT > /etc/init/docker-openvpn.conf

#Start it
sudo start docker-openvpn

# Build a client key
docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENTNAME nopass

# Build a client profile
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn