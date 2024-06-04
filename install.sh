#!/bin/sh


echo "### adding needed remote PPAs ###"
sudo add-apt-repository ppa:deadsnakes/ppa
sudo add-apt-repository ppa:gezakovacs/ppa
sudo add-apt-repository ppa:maarten-baert/simplescreenrecorder
sudo add-apt-repository ppa:touchegg/stable
sudo add-apt-repository ppa:ubuntu-mozilla-daily/ppa
sudo add-apt-repository ppa:peek-developers/stable
sudo apt-get update -y
echo "### finish adding needed remote PPAs ###"

echo "### installing curl ###"
sudo apt install curl
echo "### finished installing curl ###"

echo "### installing firefox nightly ###"
sudo apt-get update -y
sudo apt-get install firefox-trunk -y
cd  ~/Downloads
echo "### finished installing firefox nightly ###"

echo "### installing nvm, node 20 and making it default ###"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.profile
nvm install 20
nvm alias default 20
nvm use default
echo "### finished installing nvm ###"


echo "### installing python 3.11 ###"
sudo apt install software-properties-common -y
sudo apt install python3.11 -y
echo "### finished installing python ###"

echo "### installing deb files ###"
for i in *.deb;
do
  echo "installing: $i"
  sudo dpkg -i $i
done
echo "### finished installing deb files ###"

echo "### installing git ###"
sudo apt-get install git-all -y
git config --global core.autocrlf input
echo "### finished installing git ###"

echo "### installing unetbootin ###"
sudo apt-get update -y
sudo apt-get install unetbootin -y
echo "### finished installing unetbootin ###"

echo "### installing zsh ###"
sudo apt update -y
sudo apt install zsh -y
sudo usermod -s /usr/bin/zsh $(whoami)
echo "### finished installing zsh ###"

echo "### installing oh-my-zsh ###"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/Sparragus/zsh-auto-nvm-use ~/.oh-my-zsh/custom/plugins/zsh-auto-nvm-use
echo "### finished installing oh-my-zsh ###"

echo "### copying my dotfiles ###"
curl -LJO https://raw.githubusercontent.com/luizcieslak/dotfiles/master/.zshrc
curl -LJO https://raw.githubusercontent.com/luizcieslak/dotfiles/master/.hyper.js
curl -LJO https://raw.githubusercontent.com/luizcieslak/dotfiles/master/copy.sh | sh
echo "### finish copying my dotfiles ###"

echo "### setting up hyperlayout ###"
npm install -g hyperlayout hpm-cli
hpm install hyperlayout
hpm install hyper-active-tab
hpm install hyper-highlight-active-pane
hpm install hyper-opacity
hpm install hyper-tabs-enhanced
hpm install hypercwd
hpm install hyperlinks
echo "### finish setting up hyperlayout ###"

echo "### installing gpick ###"
sudo apt-get install -y gpick 
echo "### finished installing gpick ###"

echo "### installing yarn ###"
sudo apt-get install yarn -y
echo "### finished installing yarn ###"


echo "### installing pnpm ###"
wget -qO- https://get.pnpm.io/install.sh | sh -
echo "### finished installing pnpm ###"

echo "### installing flatpak  ###"
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "### finished installing flatpak  ###"

echo "### installing gnome-shell-extensions  ###"
sudo apt install gnome-shell-extensions
flatpak install flathub com.mattjakeman.ExtensionManager
echo "### finished installing gnome-shell-extensions  ###"

echo "### installing touchegg and touche ###"
sudo apt update
sudo apt install touchegg
flatpak install --user https://flathub.org/repo/appstream/com.github.joseexposito.touche.flatpakref
echo "### finished installing touchegg and touche ###"

echo "### installing atuin  ###"
bash <(curl https://raw.githubusercontent.com/ellie/atuin/main/install.sh)
echo "### finished installing atuin  ###"

echo "### installing z jumper  ###"
curl -O https://raw.githubusercontent.com/rupa/z/master/z.sh
echo "### finished installing z jumper  ###"

echo "### installing openconnect VPN  ###"
sudo apt-get install openconnect
echo "### finished installing openconnect  ###"

echo "### installing peek (gif recorder) ###"
sudo apt update
sudo apt install peek
echo "### finished installing peek  ###"

echo "### installing SSR (simple screen recording) ###"
sudo apt-get install simplescreenrecorder
echo "### finished installing SSR  ###"

echo "### installing pgadmin4 ###"
sudo apt install pgadmin4
echo "### finishedinstalling pgadmin4 ###"

echo "### installing postgresql ###"
# Import the repository signing key:
sudo apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

# Create the repository configuration file:
sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Update the package lists:
sudo apt update

# Install the latest version of PostgreSQL:
# If you want a specific version, use 'postgresql-16' or similar instead of 'postgresql'
sudo apt -y install postgresql
sudo apt install postgresql-client-common
echo "### finished installing postgresql ###"

echo "### installing docker ###"
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "### finished installing docker ###"

echo "### fix window and linux dual boot time mismatch  ###"
timedatectl set-local-rtc 1

echo "### fixing any issues with deb install ###"
sudo apt --fix-broken install