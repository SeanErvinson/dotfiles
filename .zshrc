# Setting zinit home path
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Check if zinit is present, otherwise, get it from git.
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Oh My Posh
eval "$(oh-my-posh init zsh --config ${HOME}/oh-my-posh/config.omp.yaml)"
# dotnet
#eval "$(dotnet completions script zsh)"


source "${ZINIT_HOME}/zinit.zsh"
fpath+=("$HOME/zsh/completion")

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

zinit snippet "${HOME}/zsh/autocomplete/_gh"

# Load completions
autoload -U compinit && compinit


# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

#History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

source ~/zsh/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

hs () {
 curl https://httpstat.us/$1
}

mkcd () {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

ghrc (){
  gh repo create "$1" --remote origin --source . --private
}

path+=("$HOME/.dotnet")
path+=('/opt/rider/bin')
path+=('/opt/android-studio/bin')
path+=("$HOME/.dotnet/tools")
path+=("$HOME/.pulumi/bin")
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH

#dotnet
DOTNET_ROOT="/usr/bin/dotnet"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
# fnm end

# Load Angular CLI autocompletion.
source <(ng completion script)

# bun completions
[ -s "/$HOME/.bun/_bun" ] && source "/$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# direnv
eval "$(direnv hook zsh)"
fpath+=~/.zfunc; autoload -Uz compinit; compinit

export PATH="$HOME/.local/bin:$PATH"

export _ZO_DOCTOR=0
eval "$(zoxide init zsh --cmd cd)"
