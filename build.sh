set -e
set -u

echo -e "> Installing git..."
brew install git

echo -e "\n> Installing python..."
brew install python


echo -e "\n> Installing ansible..."
pip install paramiko
pip install pyyaml
pip install jinja2
brew install https://raw.github.com/mnot/homebrew-stuff/master/ansible.rb


echo -e "\n> Configuring ansible..."
mkdir -p /usr/local/etc/ansible
cp hosts /usr/local/etc/ansible/hosts
chmod 644 /usr/local/etc/ansible/hosts

echo -e "\n> Setting permissions on remote server"
cat ~/.ssh/id_rsa.pub | ssh root@37.247.55.31 "mkdir -p ~/.ssh; cat > ~/.ssh/authorized_keys"

echo -e "\n> Testing ansible..."
ansible all -m ping -u root

echo -e "\n\nAll done."
echo "git, python and ansible are installed."



