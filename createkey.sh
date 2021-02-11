ssh-keygen -q -t rsa -N '' -f ./my_secrey_key <<<y 2>&1 >/dev/null
chmod 400 my_secrey_key.pub