# .bash_profile
source ~/.profile
source ~/.bashrc

if [ "$(uname)" == 'Darwin' ]; then
  OS='Mac'
  export PATH=$PATH:/Users/saito/Library/Android/sdk/platform-tools
  # Setting PATH for Python 2.7
  # The orginal version is saved in .bash_profile.pysave
  #PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
  #export PATH
  #alias brew="env PATH=${PATH/\/Users\/saito\/\.phpenv\/shims:/} brew"
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  export PATH="/usr/local/sbin:$PATH"
  export PATH="/usr/local/opt/opencv3/bin:$PATH"
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  OS='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
  OS='Cygwin'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi
