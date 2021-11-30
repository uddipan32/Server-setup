#!/bin/bash

check_root () {
	if [ "$(id -u)" != "0" ]; then
		echo "This script must be run ass root" 1>&2
		exit 1
	fi
}
update () {
	sudo apt-get update
}

upgrade () {
	sudo apt-get upgrade -y
}

install () {
	sudo apt-get install -y vim unzip nginx nodejs npm
	sudo npm i -g pm2
}

nginx () {
	doller='$'
	local file_name=$1
	local url=$2
	local port=$3
	echo $1
	sudo printf "server {\n\tlisten 80;\n\troot /usr/share/nginx/html;\n\tserver_name ${url}\n\t location / {\n\t\tproxy_pass http://127.0.0.1:${port};\n\t\tproxy_http_version 1.1;\n\t\tproxy_set_header Upgrade ${doller}http_upgrade\n\t\tproxy_set_header Connection 'upgrade';\n\t\tproxy_set_header Host ${doller}host;\n\t\tproxy_cache_bypass ${doller}http_upgrade;\n\t}\n}" >> "/etc/nginx/conf.d/${file_name}.conf"
	#sudo printf "server {\n\tlisten 80;\n\troot /usr/share/nginx/html;\n\tserver_name ${$2}\n\tlocation / {\n\t\tproxy_pass http://127.0.0.1:${$3};\n\t\tproxy_http_version 1.1;\n\t\tproxy_set_header Upgrade http_upgrade;\n\t\tproxy_set_header Connection 'upgrade';\n\t\tproxy_set_header Host $host;\n\t\tproxy_cache_btpass http_upgrade;\n\t}\n}" >>  "/etc/nginx/conf.d/${file_name}.conf"
}

file_name="server"
url="www.abcd.com"
port="3000"

read -p "Want to setup nginx config? (y/n): " confirm 
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
	read -p "Enter the config file name: " file_name
	read -p "Enter URL (www.abcd.com) : " url
	read -p "Port (3000) : " port
	nginx $file_name $url $port
fi

echo $file_name
echo $url
echo $port

nginx

#check_root
#update
#upgrade
#install
