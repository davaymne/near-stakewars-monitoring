#!/bin/bash

function checkPorts {
	echo -e '\n\e[42mChecking Ports...\e[0m\n'
	if ss -tulpen | awk '{print $5}' | grep -q ":3000$" ; then
		echo -e "\e[31mInstallation is not possible, port 3000 already in use.\e[39m"
		exit
	else
		echo "Port 3000 is OK"
	fi
	if ss -tulpen | awk '{print $5}' | grep -q ":9100$" ; then
		echo -e "\e[31mInstallation is not possible, port 9100 already in use.\e[39m"
		exit
	else
		echo "Port 9100 is OK"
	fi
	if ss -tulpen | awk '{print $5}' | grep -q ":9090$" ; then
		echo -e "\e[31mInstallation is not possible, port 9090 already in use.\e[39m"
		exit
	else
		echo "Port 9090 is OK"
	fi
}

function installNodeExporter {
	echo -e '\n\e[42mInstalling Node Exporter...\e[0m\n'
	mkdir -p /opt/node_exporter
	cd /opt/node_exporter
	echo -e '\n\e[42mDownloading packages...\e[0m\n'
	version=`wget -qO- -t1 -T2 "https://api.github.com/repos/prometheus/node_exporter/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
	wget -O node_exporter-${version:1}.linux-amd64.tar.gz https://github.com/prometheus/node_exporter/releases/download/${version}/node_exporter-${version:1}.linux-amd64.tar.gz
	tar xvfz node_exporter-*.*-amd64.tar.gz && cp node_exporter-*.*-amd64/node_exporter . && chown -R near_monitor:near_monitor /opt/node_exporter/
  wget -O /etc/systemd/system/node_exporter.service  https://raw.githubusercontent.com/davaymne/near-stakewars-monitoring/main/node_exporter.service
	echo -e '\n\e[42mStarting service node_exporter...\e[0m\n'
	systemctl enable --now node_exporter
	sleep 2
	if ss -tulpen | awk '{print $5}' | grep -q ":9100$" ; then
		echo -e '\n\e[42mNode Exporter has been installed successfully\e[0m\n'
	else
		echo -e "\e[31mSomething went wrong - exiting...\e[39m"
		exit
	fi
}

function installPrometheus {
	echo -e '\n\e[42mInstalling Prometheus...\e[0m\n'
	mkdir -p /var/lib/prometheus && mkdir -p /opt/prometheus
	cd /opt/prometheus
	echo -e '\n\e[42mDownloading packages...\e[0m\n'
  wget -O prometheus.yml https://raw.githubusercontent.com/davaymne/near-stakewars-monitoring/main/prometheus/prometheus.yml
	version=`wget -qO- -t1 -T2 "https://api.github.com/repos/prometheus/prometheus/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
	wget -O prometheus-${version:1}.linux-amd64.tar.gz https://github.com/prometheus/prometheus/releases/download/${version}/prometheus-${version:1}.linux-amd64.tar.gz
	tar xvfz prometheus-*.*-amd64.tar.gz && cp prometheus-*.*-amd64/prometheus . && chown -R near_monitor:near_monitor /opt/prometheus/ /var/lib/prometheus/
  wget -O /etc/systemd/system/prometheus.service https://raw.githubusercontent.com/davaymne/near-stakewars-monitoring/main/prometheus.service
	echo -e '\n\e[42mStarting service prometheus...\e[0m\n'
	systemctl enable --now prometheus
	sleep 2	
	if ss -tulpen | awk '{print $5}' | grep -q ":9090$" ; then
		echo -e '\n\e[42mPrometheus has been installed successfully\e[0m\n'
	else
		echo -e "\e[31mSomething went wrong - exiting...\e[39m"
		exit
	fi
}

function installGrafana {
	echo -e '\n\e[42mInstalling Grafana...\e[0m\n'
	echo -e '\n\e[42mDownloading packages...\e[0m\n'
	apt-get install -y gnupg2 curl software-properties-common
	apt-get update
	curl https://packages.grafana.com/gpg.key | sudo apt-key add -
	add-apt-repository -y "deb https://packages.grafana.com/oss/deb stable main"
	apt-get update
	apt-get -y install grafana
	echo -e '\n\e[42mDownloading provisioning files...\e[0m\n'
  wget -O /etc/grafana/provisioning/datasources/prometheus.yml https://raw.githubusercontent.com/davaymne/near-stakewars-monitoring/main/grafana/provisioning/datasources/prometheus.yml
  wget -O /etc/grafana/provisioning/dashboards/dashboards.yml https://raw.githubusercontent.com/davaymne/near-stakewars-monitoring/main/grafana/provisioning/dashboards/dashboards.yml
	wget -O /etc/grafana/provisioning/dashboards/near-stakewars.json https://raw.githubusercontent.com/davaymne/near-stakewars-monitoring/main/grafana/provisioning/dashboards/near-stakewars.json
	chown -R root:grafana /etc/grafana/
	echo -e '\n\e[42mStarting service grafana...\e[0m\n'
	systemctl enable --now grafana-server
  	sleep 10
	if ss -tulpen | awk '{print $5}' | grep -q ":3000$" ; then
		echo -e '\n\e[42mGrafana has been installed successfully\e[0m\n'
	else
		echo -e "\e[31mSomething went wrong - exiting...\e[39m"
		exit
	fi	
}

# Main
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
echo -e '\n\e[42mStart Installation...\e[0m\n'
useradd -rs /bin/false near_monitor
apt update && apt upgrade -y && apt install curl -y < "/dev/null"

sleep 2 && curl -s davaymne_logo.sh https://gist.githubusercontent.com/davaymne/1361bc2ea24a9f5b8ab7585691e388e5/raw/0ecca75ae872c800b9489a9c09f71dc09020bd84/davaymne_logo.sh | bash  && sleep 2
apt install htop git httpie jq tmux bc net-tools smartmontools  -y

checkPorts
installNodeExporter
installPrometheus
installGrafana

echo -e '\n\e[42mInstallation is done...\e[0m\n'
ip="http://$(curl -s https://ipinfo.io/ip):3000"
echo -e '------------------------------------'
echo -e 'To open grafana, run '$ip
echo -e 'User: admin, Pass: admin            '
echo -e '------------------------------------'
echo -e '------------------------------------'
echo -e 'Dont forget to open port 3000       '
echo -e 'sudo ufw enable 3000                '
echo -e '------------------------------------'

