# ~/.bash_profile: executed by bash(1) for login-shells.

# If ssh-agent is not running on login, start it and demand passphrase for keyring
ps cx | grep ssh-agent > /dev/null
if [ $? -ne 0 ]; then
    eval $(ssh-agent) > /dev/null
    ssh-add
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi