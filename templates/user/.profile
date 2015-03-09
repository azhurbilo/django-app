# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

export WORKON_HOME={{ django_virtualenv_root }}
source /usr/local/bin/virtualenvwrapper.sh