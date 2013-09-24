set -e
set -u

SERVER=37.247.55.31

echo -e "> Installing git..."
brew install git

echo -e "\n> Installing python..."
brew install python
pip install virtualenv

echo -e "\n> Installing ansible..."
pip install paramiko
pip install pyyaml
pip install jinja2
brew install https://raw.github.com/arialdomartini/homebrew-stuff/master/ansible.rb


echo -e "\n> Configuring ansible..."
mkdir -p /usr/local/etc/ansible
cp hosts /usr/local/etc/ansible/hosts
chmod 644 /usr/local/etc/ansible/hosts

echo -e "\n> Setting permissions on remote server"
cat ~/.ssh/id_rsa.pub | ssh root@${SERVER} "mkdir -p ~/.ssh; cat > ~/.ssh/authorized_keys"

echo -e "\n> Testing ansible..."
ansible all -m ping -u root

echo -e "\n> Installing base packages in the remote server"
ansible -v prod -a "apt-get update" -u root
ansible -v prod -a "apt-get -y install python-apt" -u root
ansible -v prod -a "apt-get -y install python-pip python-dev build-essential" -u root
ansible -v prod -a "pip install --upgrade pip" -u root
ansible -v prod -a "pip install --upgrade virtualenv" -u root

echo -e "\n> Installing packages for accelerating ansible"
ansible -v prod -a "pip install --pre python-keyczar" -u root
pip install --pre python-keyczar

echo -e "\n> Installing services on remote server"
ansible-playbook init.yml -u root


echo -e "\n\Sweet!"
echo -e "git, python and ansible are installed on this machine."
echo -e "The user ${USER} can ssh the remote $SERVER and control it with ansible"
echo -e "\n${USER} is a remote machine sudoer, and can even login as root."
echo -e "Too much power and no control may be harmful. Ansible will be your best friend." 



