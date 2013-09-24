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
    echo -e "${green}${message}${reset}"
}

function log() {
    msg "> ${1}"
}

function brew_install() {
    package=$1
    if [ $# -eq 2 ]; then name=${2}; else name=${package}; fi
    has_package=`which ${name}`
    if [ -z ${has_package} ]; then
	log "Brewing ${name}"
	brew install ${package}
    else
	log ">${name} already installed"
    fi
}

has_brew=`which brew`
if [ -z ${has_brew} ]; then
    log "Installing brew"
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

brew_install "git"
brew_install "python"
brew_install "virtualenv"

log "Installing and configuring ansible"
pip install paramiko
pip install pyyaml
pip install jinja2

brew_install "https://raw.github.com/arialdomartini/homebrew-stuff/master/ansible.rb" "ansible"

log "Configuring ansible"
mkdir -p /usr/local/etc/ansible
cp hosts /usr/local/etc/ansible/hosts
chmod 644 /usr/local/etc/ansible/hosts

log "Setting permissions on remote server authorizing ${USER}'s ssh key"
cat ~/.ssh/id_rsa.pub | ssh root@${SERVER} "mkdir -p ~/.ssh; cat > ~/.ssh/authorized_keys"

ansible-playbook init.yml -u root

msg "Accelerated mode can be used"

log "Creating a remote user ${USER} and configuring it as an administrator"
ansible-playbook account.yml -u root


msg "Sweet!"
msg "brew, git, python and ansible are installed on this machine."
msg "The user ${USER} can ssh the remote $SERVER and control it with ansible"
msg "\n${USER} is a remote machine sudoer, and can even login as root."
msg "Too much power and no control may be harmful. Ansible will be your best friend." 



