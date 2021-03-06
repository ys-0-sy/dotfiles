
# 補完機能
autoload -U compinit
compinit

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zhistory
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY
# historyを共有
setopt share_history
# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 余分な空白は詰めて記録
setopt hist_reduce_blanks
# 古いコマンドと同じものは無視
setopt hist_save_no_dups
# historyコマンドは履歴に登録しない
setopt hist_no_store
# 補完時にヒストリを自動的に展開
setopt hist_expand
# 履歴をインクリメンタルに追加
setopt inc_append_history
# export LC_ALL='ja_JP.UTF-8'

# 履歴補完
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#zplug
source ~/.zplug/init.zsh

#plugins
zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/enhancd", use:enhancd.sh
zplug "zsh-users/zsh-completions"
zplug "greymd/tmux-xpanes"
zplug "mollifier/cd-gitroot"
zplug "mollifier/anyframe"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "peco/peco", as:command, from:gh-r, use:"*amd64*"
zplug "b4b4r07/dotfiles", as:command, use:bin/peco-tmux

if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose

function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}


tmux_automatically_attach_session

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [[ "$(uname)" == 'Darwin' ]]; then
  export LC_ALL='ja_JP.UTF-8'
  powerline-daemon -q
  . /usr/local/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh
  export NODEBREW_ROOT=/usr/local/var/nodebrew
  export PATH=/usr/local/var/nodebrew/current/bin:$PATH
  export PATH="/usr/local/opt/sqlite/bin:$PATH"
  export PATH="$HOME/.yarn/bin:$PATH"
  export PATH=$(yarn global bin):$PATH
  export PATH="/usr/local/opt/python/libexec/bin:$PATH"
  export GOPATH=$HOME/.go
  function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}
  export HOMEBREW_INSTALL_CLEANUP=1
  export PATH=$PATH:/usr/local/opt/go/libexec/bin
  export PATH="$HOME/.gem/ruby/2.0.0/bin:$PATH"
  export PATH="/usr/local/lib/ruby/gems/2.5.0/bin:$PATH"
  # source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  # source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
  # export PATH="/usr/local/opt/curl/bin:$PATH"
  # export PATH="/usr/local/opt/gettext/bin:$PATH"
  export PATH="/Users/saito/Library/Android/sdk/ndk-bundle/:$PATH"
  export PATH="$HOME/platform-tools/:$PATH"
  export XDG_CONFIG_HOME=~/.config
  export PATH="$PATH:$HOME/Develop/flutter/bin"
  # PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  # MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
  eval "$(direnv hook zsh)"
elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
  export PATH=$PATH:/home/saito/.local/bin
  powerline-daemon -q
  . /home/saito/.local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh
  eval "$(direnv hook zsh)"
  export PATH=$HOME/.nodebrew/current/bin:$PATH
  source /usr/local/bin/aws_zsh_completer.sh
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
alias ssh='ssh -o ServerAliveInterval=60'
export PIPENV_VENV_IN_PROJECT=true
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
export PATH="/usr/local/sbin:$PATH"

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT="/Users/saito/Downloads/cocos2d-x-3.17.2/tools/cocos2d-console/bin"
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT="/Users/saito/Downloads"
export PATH=$COCOS_X_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT="/Users/saito/Downloads/cocos2d-x-3.17.2/templates"
export PATH=$COCOS_TEMPLATES_ROOT:$PATH
