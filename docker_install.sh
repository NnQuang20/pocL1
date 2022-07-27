#install docker : 

sudo apt install docker.io 

#get permission  for $USER and run commands docker in Jenkins pineline: 

Sudo usermod –aG docker $USER 
Sudo usermod –aG docker Jenkins 

#install Maven: 

Sudo apt install maven   

#Config mysetting in maven to add DockerHub account

Sudo nano /etc/maven/setting.xml


