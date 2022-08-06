
# NEAR stakewars monitoring
<img width="1358" alt="Screenshot 2022-07-31 at 00 04 43" src="https://user-images.githubusercontent.com/29555611/182002987-32b9e884-845d-4515-8147-e8ba55094553.png">

This is one-line bash script to get node_exporter-prometheus-grafana + grafana dashboard installed for monitoring **Near stakewars Validator Node**.

Testnet: https://github.com/near/stakewars-iii

## Prerequisite:
 - It is assumed that there is no node_exporter/prometheus/grafana installed
 - It is assumed ports: 9100, 9090, 3000 are not in use

## How to use:
On Near validator server run
```
wget -q -O near-stakewars-monitoring-installer.sh https://raw.githubusercontent.com/davaymne/near-stakewars-monitoring/main/near-stakewars-monitoring-installer.sh && chmod +x near-stakewars-monitoring-installer.sh && sudo /bin/bash near-stakewars-monitoring-installer.sh
```
Go to you web browser and enter:
```
http://YOUR-NODE-IP:3000/
```
Use Grafana default credentials:
 - User: admin
 - Pass: admin
 
 ## Optional: Configure Alert Notification
 
 ### Set up Telegram Bot 
 
 - Telegram bot
@BotFather - https://core.telegram.org/bots (https://core.telegram.org/bots#6-botfather)

 - Create Telegram group and add your bot into the group to receive notifications from bot in this group 
 
 ### Set up Alerts Contact Point
 
 - Go to your grafana and add Contact Point
<img width="1251" alt="Screenshot 2022-07-21 at 00 34 24" src="https://user-images.githubusercontent.com/29555611/180100288-c480d49a-4031-485b-a5e8-f512f070fd5e.png">

 
 Official website: https://grafana.com/docs/grafana/latest/alerting/contact-points/create-contact-point/
 
### Set up Alert Rule for Klaytn node

 - Go to Grafana -> HyperNode dashboard -> Klaytn Sync Rate chart and select `Edit`
 
 <img width="680" alt="Screenshot 2022-07-21 at 00 43 03" src="https://user-images.githubusercontent.com/29555611/180100933-f6292163-ae27-4de1-b83b-0d392722b5cb.png">

 - Click `Create Alert Rule from this panel`
 
 <img width="1011" alt="Screenshot 2022-07-21 at 00 46 07" src="https://user-images.githubusercontent.com/29555611/180101210-c3552803-28cd-4818-93a2-30747b608d66.png">

 - Configure Alert Rule as per screenshots below
 
 <img width="1359" alt="Screenshot 2022-07-21 at 00 52 09" src="https://user-images.githubusercontent.com/29555611/180101832-54268bc1-726b-4a8b-841b-998dc72e4b54.png">

 <img width="1290" alt="Screenshot 2022-07-21 at 00 52 28" src="https://user-images.githubusercontent.com/29555611/180101876-69687e48-20bb-4803-bec7-0f2730aef0e8.png">
 
 <img width="1037" alt="Screenshot 2022-07-21 at 00 52 48" src="https://user-images.githubusercontent.com/29555611/180101899-c9421531-60dc-455e-b2d0-d7e1c4788982.png">

 <img width="1363" alt="Screenshot 2022-07-21 at 00 53 08" src="https://user-images.githubusercontent.com/29555611/180101919-7109a743-6c44-45ca-bcb6-f07e1164a544.png">

Official website: https://grafana.com/docs/grafana/latest/alerting/alerting-rules/create-grafana-managed-rule/
 
 
