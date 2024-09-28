# Import my environment

## mac

### download softwares

```sh
#https://dev.mysql.com/downloads/workbench/
#Finder > ctrl + K
#MySQL WorkBench > Tools > Configuration > Restore connections
#https://rstudio.com/products/rstudio/download/#download
#https://www.skype.com/en/thank-you-skype/
# https://www.synaptics.com/products/displaylink-graphics/downloads/macos
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo softwareupdate --install-rosetta
sudo installer -pkg AWSCLIV2.pkg -target /
# https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html
sudo installer -pkg Downloads/aws-sam-cli-macos-arm64.pkg -target /
# VScode - installation by brew
#npm install -g vscode
# Auto Markdown TOC, Hunter Tran
#Awesome Emacs Keymap, Yuichiro Tsuchiya
# AWS CLI Configure, Mark Tucker
# aws-cloudformation-yaml, Daniel Thielking
# Dev Containers, Docker, Black Formatter, isort, Jupyter, Pylance, Pylint, Python, Microsoft
# Edit csv, janisdd
# ipython, Hoang Kim Lai
# JSON, Beautify JSON, Meezilla
# Prettier - Code Formatter, Prettier
# swagger-jsdoc Comment Formatter, Arnau Jiménez
#Terminal Tools, Glenn (lglong519)
# XML Formatter, Fabian Lauer
```

### [brew](https://brew.sh/)

```sh
# chsh -s /bin/bash # only the first time
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "eval \$(/opt/homebrew/bin/brew shellenv)" >> ~/.bash_profile
brew --version
#brew tap aws/tap
#brew install awscli aws-sam-cli
brew install --cask amazon-chime
brew install caffeine
#brew install chromium
brew install --cask dbeaver-community
brew install discord
brew install docker docker-compose
brew install --cask emacs
brew install --cask gimp
brew install google-chrome
brew install firefox
brew install git bash-completion
brew install --cask inkscape
brew install iterm2
#iTerm2 > Preferences > Profiles > Color Presets > 
# iTerm2 > Settings > Profiles > Colors > Color Presets > Solarized Dark
# iTerm2 > Install Shell Integration
brew install meld
brew install --cask microsoft-teams
#brew install node
brew install nodeenv
brew install --cask obs
brew install openfortivpn
brew install --cask rar
brew install sevenzip
brew install spectacle
brew install telnet
brew install tmux
brew install virtualenv
brew install visual-studio-code
brew install --cask zoom
#brew tap ringohub/redis-cli
#brew update && brew doctor
#brew install redis-cli
```

### env

```sh
#brew install eqnxio/cimpress-cloud-engineering/stskeygen
#curl https://bootstrap.pypa.io/get-pip.py -o ~/Documents/configurations/get-pip.py
#sudo python ~/Documents/configurations/get-pip.py
#pip install sceptre --user # some problems without --user and with sudo
# add /Users/alessandra.bilardi/Library/Python/2.7/bin on .bash_profile
#apm config set strict-ssl false # for atom packages installation
#npm config set strict-ssl false # for serverless packages installation
#brew install pyenv
#pyenv install 3.6.6 # brew install python3 installs python3.7
#pip3 install virtualenv
# Pip, setuptools, and wheel have been installed. To update them run
# pip3 install --upgrade pip setuptools wheel
#pip3 install awscli --upgrade
#npm install -g aws-cdk # now only in pyenv
cd ~/
virtualenv .env
source .env/bin/activate
# pip3 install ipykernel
pip3 install -r requirements.txt
#python3 -m ipykernel install --user --name jupyter --display-name "my_jupyter_kernel"
ipython kernel install --user --name=my_jupyter_kernel
# close and open again vscode
```

## pi

### download softwares

```sh
apt-get install emacs-nox code tmux awscli
pip3 install virtualenv
curl -fsSL https://get.docker.com | sh
usermod -aG docker pi
reboot
```

## ubuntu

### download softwares

```sh
apt-get install curl emacs-nox tmux python3-pip meld
pip3 install -r requirements.txt
curl -fsSL https://get.docker.com | sh
usermod -aG docker pi
reboot
```

### brew

```sh
apt-get install build-essential procps curl file git
exit
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
brew --version
brew tap aws/tap
brew install awscli aws-sam-cli
```

### env

```sh
cd github/jupyter/
virtualenv .env
source .env/bin/activate
# pip3 install ipykernel
pip3 install -r requirements.txt
python3 -m ipykernel install --user --name jupyter --display-name "my_jupyter_kernel"
# close and open again vscode
```

### M708
https://help.ubuntu.com/community/TabletSetupWizardpen#Method_2
https://bbs.archlinux.org/viewtopic.php?id=172981
https://wiki.archlinux.org/title/wacom_tablet
https://linux.die.net/man/4/wacom
https://www.ugee.com/it/download/m708
```sh
wget https://github.com/DIGImend/digimend-kernel-drivers/releases/download/v10/digimend-dkms_10_all.deb
dpkg -i digimend-dkms_10_all.deb
reboot
ls /usr/share/X11/xorg.conf.d/50-digimend.conf
ls /dev/input/by-id/usb*
xsetwacom list
xsetwacom --set 9 Mode Relative
xinput list
xinput --list-props 9
xinput --set-prop 9 335 1
lsusb
evtest
```

## configurations

```sh
cd ~/
git clone https://github.com/bilardi/my-environment .
#bash bin/env-update
cd bin
ln -s ../.tmux/plugins/tmux-resurrect tmux-resurrect
cd -
git submodule init
git submodule update --recursive
```

## extensions

* https://chrome.google.com/webstore/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai
* https://chrome.google.com/webstore/detail/time-calculator/ehildbclipkplmjfidlkkplaieiglaml
* https://chrome.google.com/webstore/detail/lastpass-free-password-ma/hdokiejnpimakedhajhdlcegeplioahd

## import

* authenticator.*.txt
* bookmarks.*.html

## git

```sh
git status
find . -type d -exec chmod 0755 {} \;
find . -type f -exec chmod 0644 {} \;
git status
git diff | grep -B 1 "old mode" | grep "^diff" | awk '{print $3}' | sed 's#^a/#./#' | while read f; do git restore $f; done
```
