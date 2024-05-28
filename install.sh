#!/bin/sh

echo "### installing curl ###"
sudo apt install curl
echo "### finished installing curl ###"

echo "### installing firefox nightly ###"
sudo add-apt-repository ppa:ubuntu-mozilla-daily/ppa
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
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.11 -y
echo "### finished installing python ###"

echo "### installing deb files ###"

for i in *.deb;
do
  echo "installing: $i"
  sudo dpkg -i $i
done

echo "### finished installing deb files ###"

echo "### installing unetbootin ###"

sudo add-apt-repository ppa:gezakovacs/ppa
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

echo "### finished installing oh-my-zsh ###"

echo "### copying my dotfiles ###"

curl -LJO https://raw.githubusercontent.com/luizcieslak/dotfiles/master/.zshrc
curl -LJO https://raw.githubusercontent.com/luizcieslak/dotfiles/master/.hyper.js
curl -LJO https://raw.githubusercontent.com/luizcieslak/dotfiles/master/copy.sh | sh

echo “source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh” >> ~/.zshrc
echo "### copying installing  my dotfiles ###"

echo "### installing git ###"

sudo apt-get install git-all -y

echo "### finished installing git ###"

echo "### installing gpick ###"

sudo apt-get update -y
sudo apt-get install -y gpick 

echo "### finished installing gpick ###"

echo "### installing yarn ###"

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update -y
sudo apt-get install yarn -y

echo "### finished installing yarn ###"


echo "### installing pnpm ###"
wget -qO- https://get.pnpm.io/install.sh | sh -
echo "### finished installing pnpm ###"

echo "### installing spotify ###"
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update -y && sudo apt-get install spotify-client
echo "### finished installing spotify ###"

echo "### installing masterpdf ###"
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update -y && sudo apt-get install spotify-client
echo "### finished installing masterpdf ###"

echo "### installing flatpak  ###"
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "### finished installing flatpak  ###"

echo "### installing openrazer  ###"
sudo gpasswd -a $USER plugdev
sudo apt install software-properties-gtk
sudo add-apt-repository ppa:openrazer/stable
sudo apt update
sudo apt install openrazer-meta
echo "### finished installing openrazer  ###"

echo "### installing gnome-shell-extensions  ###"
sudo apt install gnome-shell-extensions
echo "### finished installing gnome-shell-extensions  ###"

echo "### installing touchegg  ###"
sudo add-apt-repository ppa:touchegg/stable
sudo apt update
sudo apt install touchegg
echo "### finished installing touchegg  ###"

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
sudo add-apt-repository ppa:peek-developers/stable
sudo apt update
sudo apt install peek
echo "### finished installing peek  ###"

echo "### installing SSR (simple screen recording) ###"
sudo add-apt-repository ppa:maarten-baert/simplescreenrecorder
sudo apt-get update -y
sudo apt-get install simplescreenrecorder
echo "### finished installing SSR  ###"

echo "### fix window and linux dual boot time mismatch  ###"
timedatectl set-local-rtc 1