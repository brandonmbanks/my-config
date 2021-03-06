# ssh dir
mkdir -p $HOME/.ssh
chmod 0700 $HOME/.ssh

# install homebrew
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    : # homebrew already installed
fi

# installing packages
brew update

brew install \
  coreutils automake autoconf openssl \
  libyaml readline libxslt libtool unixodbc \
  unzip curl

xcode-select --install

# download antigen
[ -d ~/.zgen ] || git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# git
brew install git
git config --global color.ui auto

# kubernetes
brew cask install minikube
# download asdf if not exists
[ -d ~/.asdf ] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
cd -
if [ $(cat ~/.zshrc | grep -c "asdf") -eq 0 ];
then
    echo '\n# asdf' >> ~/.zshrc
    echo '. $HOME/.asdf/asdf.sh' >> ~/.zshrc
    echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
    source ~/.zshrc > /dev/null 2>&1 # reload shell
else
    : # asdf sh completion already exists
fi
# install kubectl
asdf plugin-add kubectl
asdf install kubectl 1.14.1
touch ~/.tool-versions
echo "kubectl 1.14.1" > ~/.tool-versions

# node
# download nvm if not exists
[ -d "~/.nvm" ] || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash && source ~/.zshrc > /dev/null 2>&1
nvm install node

# python
# download pyenv if not exists
[ -d ~/.pyenv ] || git clone https://github.com/pyenv/pyenv.git ~/.pyenv
if [ $(cat ~/.zshrc | grep -c "pyenv") -eq 0 ];
then
    echo '\n# pyenv' >> ~/.zshrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
    source ~/.zshrc > /dev/null 2>&1 # reload shell
else
    : # pyenv sh completion already exists
fi
pyenv install 3.7.5
pyenv global 3.7.5
exec zsh # reload shell

