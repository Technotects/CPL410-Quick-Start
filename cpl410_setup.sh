#!/bin/bash
##
## GE CPL410 Demonstration Installation
## 
## GE Automation & Controls
## Warren Jackson (GE Power) <Warren.Jackson@ge.com>
##
## Technotects, Inc (Partner/System Integrator)
## www.technotects.com
## 215-361-8124 x102
## mikemalone@technotects.com
## 
## Author: sungsyn@technotects.com
## Date: 2018-06-15
## Version: 1.0
##

# NOTE: REQUIRES PME demo installation on the PLC side of the CPL410
# Alternatively, a public OPC UA Server based version is available (inquire) that can 
#   run without the GE PLC if needed for industrial computers, etc.

# Execute on GE CPL410 device (Ubuntu Linux 16.04)
# System will reboot explicitly/automatically after running the script

DATASOURCE="/etc/grafana/provisioning/datasources/datasource.yaml"
LOGGER_CONFIG="./node-opcua-logger/config.toml"

# Install Grub
sudo apt-get install -y grub
sudo update-grub

# Update Ubuntu OS
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update

# Install Python Variants
sudo apt-get install -y python
sudo apt-get install -y python3

# Install Required Tools
sudo apt-get install -y net-tools
sudo apt-get install -y git
sudo apt-get install -y nodejs-legacy
sudo apt-get install -y npm
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential
sudo npm install -y nedb
sudo npm install -y toml

# Install PM2
sudo npm install -g pm2
sudo pm2 startup systemd

# Install InfluxDB
sudo apt-get install -y influxdb
sudo apt-get install -y influxdb-client
sudo sed -i 's/bind-address = ":8086"/bind-address = ":8095"/g' /etc/influxdb/influxdb.conf
sudo systemctl start influxdb
sudo influx -execute 'CREATE DATABASE opcdemo'

# Install Logger (node)
sudo git clone https://github.com/coussej/node-opcua-logger.git
sudo npm install -y ./node-opcua-logger
sudo pm2 start ./node-opcua-logger/logger.js
sudo pm2 save

# Modify default config.toml file
sudo chmod 775 $LOGGER_CONFIG
sudo echo $"" >> $LOGGER_CONFIG
ping -c5 192.168.180.2
if [ $? -eq 0 ]
then
sudo cat << EOF > $LOGGER_CONFIG
[input]
url             = "opc.tcp://192.168.180.2:4840"
failoverTimeout = 5000 # time to wait before reconnection in case of failure
[output]
name             = "opcdemo"
type             = "influxdb"
host             = "127.0.0.1"
port             = 8095
protocol         = "http"
username         = "opcdemouser"
password         = "OPCDemoUser1"
database         = "opcdemo"
failoverTimeout  = 10000
bufferMaxSize    = 64
writeInterval    = 3000
writeMaxPoints   = 1000

# A polled node:
[[measurements]]
name               = "SawValue"
dataType           = "number"
tags               = { tag1 = "SawValue"}
nodeId             = "ns=2;s=SawValue"
collectionType     = "polled"
pollRate           = 60     # samples / minute.
deadbandAbsolute   = 0      # Absolute max difference for a value not to be collected
deadbandRelative   = 0.0    # Relative max difference for a value not to be collected

# A monitored node
[[measurements]]
name               = "SinValue"
dataType           = "number"
tags               = { tag1 = "SinValue" }
nodeId             = "ns=2;s=SinValue"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0 		# Absolute max difference for a value not to be collected
deadbandRelative   = 0    	# Relative max difference for a value not to be collecte#

# A monitored node
[[measurements]]
name               = "Temp_RSTi"
dataType           = "number"
tags               = { tag1 = "Temp_RSTi" }
nodeId             = "ns=2;s=Temp_RSTi"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_AI1"
dataType           = "number"
tags               = { tag1 = "OPC_AI1" }
nodeId             = "ns=2;s=OPC_AI1"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_AI2"
dataType           = "number"
tags               = { tag1 = "OPC_AI2" }
nodeId             = "ns=2;s=OPC_AI2"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_AI3"
dataType           = "number"
tags               = { tag1 = "OPC_AI3" }
nodeId             = "ns=2;s=OPC_AI3"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_AI4"
dataType           = "number"
tags               = { tag1 = "OPC_AI4" }
nodeId             = "ns=2;s=OPC_AI4"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_AI5"
dataType           = "number"
tags               = { tag1 = "OPC_AI5" }
nodeId             = "ns=2;s=OPC_AI5"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_AI6"
dataType           = "number"
tags               = { tag1 = "OPC_AI6" }
nodeId             = "ns=2;s=OPC_AI6"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_AI7"
dataType           = "number"
tags               = { tag1 = "OPC_AI7" }
nodeId             = "ns=2;s=OPC_AI7"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_AI8"
dataType           = "number"
tags               = { tag1 = "OPC_AI8" }
nodeId             = "ns=2;s=OPC_AI8"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_DI1"
dataType           = "number"
tags               = { tag1 = "OPC_DI1" }
nodeId             = "ns=2;s=OPC_DI1"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0


# A monitored node
[[measurements]]
name		   = "OPC_DI2"
dataType           = "number"
tags               = { tag1 = "OPC_DI2" }
nodeId             = "ns=2;s=OPC_DI2"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_DI3"
dataType           = "number"
tags               = { tag1 = "OPC_DI3" }
nodeId             = "ns=2;s=OPC_DI3"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_DI4"
dataType           = "number"
tags               = { tag1 = "OPC_DI4" }
nodeId             = "ns=2;s=OPC_DI4"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_DI5"
dataType           = "number"
tags               = { tag1 = "OPC_DI5" }
nodeId             = "ns=2;s=OPC_DI5"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_DI6"
dataType           = "number"
tags               = { tag1 = "OPC_DI6" }
nodeId             = "ns=2;s=OPC_DI6"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_DI7"
dataType           = "number"
tags               = { tag1 = "OPC_DI7" }
nodeId             = "ns=2;s=OPC_DI7"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0

# A monitored node
[[measurements]]
name		   = "OPC_DI8"
dataType           = "number"
tags               = { tag1 = "OPC_DI8" }
nodeId             = "ns=2;s=OPC_DI8"
collectionType     = "polled"
pollRate           = 60
deadbandAbsolute   = 0
deadbandRelative   = 0.0
EOF
else
sudo cat << EOF > $LOGGER_CONFIG
[input]
url             = "opc.tcp://opcuademo.sterfive.com:26543"
failoverTimeout = 5000 # time to wait before reconnection in case of failure
[output]
name             = "opcdemo"
type             = "influxdb"
host             = "127.0.0.1"
port             = 8095
protocol         = "http"
username         = "opcdemouser"
password         = "OPCDemoUser1"
database         = "opcdemo"
failoverTimeout  = 10000
bufferMaxSize    = 64
writeInterval    = 3000
writeMaxPoints   = 1000

# A polled node:
[[measurements]]
name               = "Temperature"
dataType           = "number"
tags               = { tag1 = "Temperature"}
nodeId             = "ns=1;s=Temperature"
collectionType     = "polled"
pollRate           = 60     # samples / minute.
deadbandAbsolute   = 0      # Absolute max difference for a value not to be collected
deadbandRelative   = 0.0    # Relative max difference for a value not to be collected
EOF
fi

# Install Grafana
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_5.1.3_amd64.deb
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_5.1.3_amd64.deb
sudo sed -i 's/;http_port = 3000/http_port = 4000/g' /etc/grafana/grafana.ini
sudo service grafana-server start
sudo update-rc.d grafana-server defaults
sudo touch $DATASOURCE
sudo chmod 775 $DATASOURCE
sudo cat << EOF > $DATASOURCE
apiVersion: 1

datasources:
  - name: opcdemo
    type: influxdb
    access: proxy
    database: opcdemo
    user: admin
    password: admin
    url: http://localhost:8095
EOF
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

sudo reboot
