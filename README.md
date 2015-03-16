docker-munki-enroll
-----
A container that serves static and PHP files at http://munki/repo using nginx. PHP is required for munki-enroll. This is basically hunty1's PHP-enabled `munki-docker` container, with git added, and a script to clone the munki-enroll files into the munki repository.

nginx expects the munki repo content to be located at /munki_repo. Use a data container and the --volumes-from option to add files.

Creating a Data Container:
---
Create a data-only container to host the Munki repo:  
	`docker run -d --name munki-data --entrypoint /bin/echo grahamrpugh/munki-enroll Data-only container for munki`

For more info on data containers read [Tom Offermann](http://www.offermann.us/2013/12/tiny-docker-pieces-loosely-joined.html)'s blog post and the [official documentation](https://docs.docker.com/userguide/dockervolumes/). 

Run the Munki container:
-----
If you have an existing Munki repo on the host, you can mount that folder directly by using this option instead of --volumes-from:

`docker run -d --name munki -v /path/to/munki/repo:/munki_repo -p 8088:80 -h munki grahamrpugh/munki-enroll`

Otherwise, use --volumes-from the data container:  
	`docker run -d --name munki --volumes-from munki-data -p 8088:80 -h munki grahamrpugh/munki-enroll`

Change the external port to suit your environment (ports are listed as external:internal).
	

Populate the Munki server (optional):
-----
The easiest way to populate the Munki server is to hook the munki-data volume up to a Samba container and share it out to a Mac, using NMC Spadden's [SMB-Munki container](https://registry.hub.docker.com/u/nmcspadden/smb-munki/):  

1.	`docker pull nmcspadden/smb-munki`
2.	`docker run -d -p 445:445 --volumes-from munki-data --name smb nmcspadden/smb-munki`
3.	You may need to change permissions on the mounted share, or change the samba.conf to allow for guest read/write permissions. One example:  
	`chown -R nobody:nogroup /munki_repo`  
	`chmod -R ugo+rwx /munki_repo`
4.	Populate the Munki repo using the usual tools - munkiimport, manifestutil, makecatalogs, etc.

Import the Munki-enroll folder:
-----
1.  `mkdir -p ~/munki-enroll`
2.  `curl -s https://raw.githubusercontent.com/grahampugh/munki-enroll/master/setup.sh -o ~/munki-enroll/setup.sh`
3.  `chmod +x ~/munki-enroll/setup.sh`
4.  `~/munki-enroll/setup.sh`
