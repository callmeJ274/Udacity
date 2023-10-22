# Set up mysql in ec2 to run in localhost
- SSH to EC2
- Install MySQL server:
sudo su -
dnf -y localinstall https://dev.mysql.com/get/mysql80-community-release-el9-4.noarch.rpm
dnf -y install mysql mysql-community-client
- Then run connect to remote RDS
mysql -h RDS-id -u admin -p udacity