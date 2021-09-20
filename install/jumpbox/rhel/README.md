# RHEL 8 setup steps

- Ensure subscription is in place
- As root `sudo usermod -aG wheel $USER` to add user to sudoers groups
- Install git
  - `sudo yum update`
  - `sudo yum install git`
- Set hostname
  - `sudo vi /etc/hostname`
  - `sudo vi /etc/hosts`
  - `sudo reboot`
- Install docker-ce
  - `sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo`
  - `sudo dnf install docker-ce --nobest -y --allowerasing`
  - `sudo systemctl disable firewalld`
  - `sudo systemctl enable --now docker`
  - `sudo usermod -aG docker $USER`