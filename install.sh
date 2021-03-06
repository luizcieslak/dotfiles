#!/bin/sh


echo "### installing chromium ###"

sudo apt update -y
sudo apt install chromium-browser -y

echo "### finished installing chromium ###"


echo "### installing firefox(es) ###"

sudo add-apt-repository ppa:ubuntu-mozilla-daily/ppa

sudo apt-get update -y
sudo apt-get install firefox-trunk -y
sudo apt-get install firefox -y

sudo apt-get update -y
sudo apt-get install firefox -y

sudo cp -rp firefox-83.0b1.tar.bz2 /opt
cd /opt
sudo tar xjf firefox-83.0b1.tar.bz2
sudo rm -rf firefox-67.0b10.tar.bz2

sudo mv firefox firefox-dev
sudo chown -R $USER /opt/firefox-dev

cat > ~/.local/share/applications/firefoxDeveloperEdition.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Developer Edition
Exec=/opt/firefox-dev/firefox
Icon=/opt/firefox-dev/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;Favorite;
MimeType=text/html;text/xml;application/xhtml_xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp; X-Ayatana-Desktop-Shortcuts=NewWindow;NewIncognitos;
EOL

echo "### finished installing firefox(es) ###"


echo "### installing postman ###"

# wget -O - https://gist.githubusercontent.com/SanderTheDragon/1331397932abaa1d6fbbf63baed5f043/raw/postman-deb.sh | sh
curl https://gist.githubusercontent.com/SanderTheDragon/1331397932abaa1d6fbbf63baed5f043/raw/postman-deb.sh | sh

echo "### finished installing postman ###"


echo "### installing nvm, node 15.0.0 and 12.19.0 making 12 default ###"

curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh -o install_nvm.sh
bash install_nvm.sh
source ~/.profile

nvm install 15
nvm install 12.19.0

nvm alias default 12.19.0

nvm use default

echo "### finished installing nvm ###"


echo "### installing python 3.9 ###"

sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.9 -y

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
sudo apt-get update
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

echo "### installing f.lux ###"

sudo add-apt-repository ppa:nathan-renniewaldock/flux
sudo apt-get update -y
sudo apt-get install fluxgui -y

echo "### finished installing f.lux ###"

echo "### installing yarn ###"

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update -y
sudo apt-get install yarn -y

echo "### finished installing yarn ###"