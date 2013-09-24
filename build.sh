set -e
set -u

SERVER=37.247.55.31

red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
violet="\033[0;35m"
reset="\033[0m"

function msg() {
    message=$1
    echo -e "${green}> ${message}...${reset}"
}

function brew_install() {
    package=$1
    if [ $# -eq 2 ]; then name=${2}; else name=${package}; fi
    has_package=`which ${package}`
    if [ -z ${has_package} ]; then
	msg "Brewing ${name}"
	brew install ${package}
    else
	msg "${name} already installed"
    fi
}

has_brew=`which brew`
if [ -z ${has_brew} ]; then
    msg "Installing brew"
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

brew_install "git"
brew_install "python"
brew_install "virtualenv"

msg "Installing and configuring ansible"
pip install paramiko
pip install pyyaml
pip install jinja2

brew_install "https://raw.github.com/arialdomartini/homebrew-stuff/master/ansible.rb" "ansible"

msg "Configuring ansible"
mkdir -p /usr/local/etc/ansible
cp hosts /usr/local/etc/ansible/hosts
chmod 644 /usr/local/etc/ansible/hosts

msg "Setting permissions on remote server"
cat ~/.ssh/id_rsa.pub | ssh root@${SERVER} "mkdir -p ~/.ssh; cat > ~/.ssh/authorized_keys"

#echo -e "\n> Testing ansible..."
#ansible all -m ping -u root

#echo -e "\n> Installing base packages in the remote server"
#ansible -v prod -a "apt-get update" -u root
#ansible -v prod -a "apt-get -y install python-apt" -u root
#ansible -v prod -a "apt-get -y install python-pip python-dev build-essential" -u root
#ansible -v prod -a "pip install --upgrade pip" -u root
#ansible -v prod -a "pip install --upgrade virtualenv" -u root

#echo -e "\n> Installing packages for accelerating ansible"
#ansible -v prod -a "pip install --pre python-keyczar" -u root
#pip install --pre python-keyczar

#echo -e "\n> Installing services on remote server"
#ansible-playbook init.yml -u root


#echo -e "\n\Sweet!"
#echo -e "git, python and ansible are installed on this machine."
#echo -e "The user ${USER} can ssh the remote $SERVER and control it with ansible"
#echo -e "\n${USER} is a remote machine sudoer, and can even login as root."
#echo -e "Too much power and no control may be harmful. Ansible will be your best friend." 



