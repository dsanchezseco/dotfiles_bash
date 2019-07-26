# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias d='docker'
alias dc='docker-compose'
alias k='kubectl'
alias tf='terraform'
alias ap='ansible-playbook'
export PATH=$HOME/bin:$PATH
export KUBECONFIG=$HOME/.kube/config

# use neovim instead of defautl vim
alias vim="nvim"
alias vi="nvim"
alias vimdiff='nvim -d'
export EDITOR=nvim

# make python3 the default for user actions
alias python="python3"
alias pip="pip3"

alias tree="tree -I .git -a"

alias search="grep -rnwe"

# aditional exports
export PATH=$HOME/bin:$HOME/.local/bin:$PATH
