#Insta-VPN

A simple tool that lets you create deploy an [OpenVPN docker image](https://hub.docker.com/r/kylemanna/openvpn/) to a remote Ubuntu instance. (Only tested on Ubuntu 14.10 in DigitalOcean)

##Caveats:

- The SSH key used to log into the instance must be in your keychain.
- The whole thing is set up and run as the root user.

##Usage:

###Deploy the Server
Provided you have root access and the ssh key is in your keychain, deploy the server using:

```bash
./install_remote_vpn.bash <host-ip-address> <client-name>
```
And enter the appropriate details as you are prompted. Once the script is finished the profile is located in `~/client-name.ovpn`

This can be imported into various OpenVPN client software

###Create a new client
Once again, as long as you have root access and the ssh key is in your keychain, create a client using:
```bash
./create_client.bash <host-ip-address> <client-name>
```

And enter the appropriate details as you are prompted. Once the script is finished the profile is located in `~/client-name.ovpn`

## More Information

There are three scripts

- `docker_ovpn.bash`- This runs on the remote instance, installs docker and sets up the OpenVPN container. The user is prompted for a CA password while this script runs. It also creates a single client to start with
- `install_remote_vpn.bash` - Copies the `docker_ovpn.bash` script over and executes it. As part of this an intial OpenVPN client config is created. This file is downloaded from the instance
- `create_client.bash` - Executes a command on the remote instance to which creates a new client key + profile. The user is prompted for the original CA password when this script is run.