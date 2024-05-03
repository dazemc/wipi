# wipi

Flutter app for sending wifi credentials to linux device running a local flask server. Originally made with a raspberry pi in mind, but should be compatible with any linux device using NetworkManger, iwd, python^3.10, and Flask. The flask_app directory cantains the files needed to host the server on the device. Wifi credentials are not saved but instead read directly from the configs at runtime, will require read/write permissions of /etc/NetworkManager/system-connections/ and /etc/NetworkManager/conf.d/
<br>
<br>
Currently working on (ordered);<br> systemd service to check for nmcli connections and if none are connected enable AP mode and start flask_app,<br> command feedback,<br> ping from app,<br> sending scripts(python eval & bash) from app,<br> time-based OTP,<br> password encryption,<br> and ssh app.
<br>
<br>
<br>
<img src="./repo_assets/images/wipiscreenshot.png" width="200"/>
<br>
<br>
<br>
<img src="./repo_assets/images/wipiaddscreenshot.png" width="200"/>

