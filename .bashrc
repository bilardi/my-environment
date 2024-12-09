# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/bin:/Users/alessandra.bilardi/Library/Python/2.7/bin:/Library/Frameworks/Python.framework/Versions/3.6/bin"
# PS1="\h:\W \u\$" # default

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="[\t] \w \$(parse_git_branch)$ "
# if [ -f  /etc/bash_completion ]; then
#      .  /etc/bash_completion
# fi
if [ -d /etc/profile.d ]; then
    [[ -r "/etc/profile.d/bash_completion.sh" ]] && source "/etc/profile.d/bash_completion.sh"
fi
