#!/bin/bash

# Help Function
usage() {
    echo ""
    echo "Usage: $0 -n name -e email"
    echo -e "\t-n Your name"
    echo -e "\t-e Your email address"
    exit 1 # Exit script after printing help
}

# Check parameters are provided
while getopts "n:e:" opt; do
    case "$opt" in
    n) name="$OPTARG" ;;
    e) email="$OPTARG" ;;
    ?) usage ;; # Print help function in case parameters are not provided
    esac
done

# Print help function if any parameters are missing
if [ -z "$name" ] || [ -z "$email" ]; then
    echo "Some or all of the parameters are empty"
    usage
fi

# Install XCode Command Line Tools Package
xcode-select --install

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Git
brew install git

# Install Visual Studio Code
brew cask install visual-studio-code
cat vscode-extensions.txt | xargs -L1 code --install-extension

# Install Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install stable

# Set Git Globals
git config --global user.name "$name"
git config --global user.email "$email"
echo "Git identity updated to: "
echo "$(git config --list)"

# Install Commitizen
npm install -g commitizen
npm install -g cz-conventional-changelog
npm install -g standard-version
echo '{ "path": "cz-conventional-changelog" }' >~/.czrc
echo 'Commitizen installed'

# Set up Global Git Hooks
git config --global init.templatedir '~/.git-templates'
mkdir -p ~/.git-templates/hooks
cat >~/.git-templates/hooks/prepare-commit-msg <<EOF
#!/bin/bash
exec < /dev/tty && git-cz --hook || true
EOF
chmod +x ~/.git-templates/hooks/prepare-commit-msg
echo "Git hook created"

# Install Talisman
echo "Install Talisman Pre-Commit Hooks"
curl --silent https://raw.githubusercontent.com/thoughtworks/talisman/master/global_install_scripts/install.bash >/tmp/install_talisman.bash && /bin/bash /tmp/install_talisman.bash

# Create Public/Private KeyPair
ssh-keygen -t rsa -b 4096 -C "$email" -q

# Update SSH Agent Config
cat <<EOF >~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
EOF

# Add SSH Private Key to SSH Agent
ssh-add -K ~/.ssh/id_rsa

# Check GitHub Connectivity
echo "Add your public key to your GitHub account and check your connectivity using: ssh -T git@github.com"

# Install Terraform
brew install terraform

# Install Google Chrome
brew cask install google-chrome

# Install Spotify
brew cask install spotify

# Install WhatsApp
brew cask install whatsapp

# Install Postman
brew cask install postman

# Install Docker
brew cask install docker

# Install AWS CLI
brew install awscli
