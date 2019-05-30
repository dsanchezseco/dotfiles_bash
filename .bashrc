# TODO: how to set this two that are going to possibily be already in the .bashrc??
### force_color_prompt=yes

### if [ "$color_prompt" = yes ]; then
###     PS1='${debian_chroot:+($debian_chroot)}╭╴ \[\033[01;31m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(git_branch) \n│ \n╰╴ $ '
### else
###     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
### fi

# TODO: load aliases
# TODO: load aws_load_session.sh >> TODO: setup of config files
# TODO: load git_branch_info.sh

# aditional exports
export PATH=$HOME/bin:$PATH
export KUBECONFIG=$HOME/.kube/config
export EDITOR=nvim
export PATH=$HOME/bin:$HOME/.local/bin:$PATH
export ARTIFACTORY_API_USER=
export ARTIFACTORY_API_KEY=
