# Ender-3-v3-KE
Creality Ender 3 v3 KE software setup

Add support for SFTP
  - install entware
  - install openssh-server
  - install openssh-sftp-server

Add external temperature sensor support
  - add python script that reads external temperatures and write them to a temperature_host file, to be used in Klipper
  - Arduino NANO code to send the sensor data over the USB to the python script
