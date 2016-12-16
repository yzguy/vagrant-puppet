#!/bin/bash

if [[ $(which puppet) != '/usr/local/bin/puppet' ]]; then
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile
fi
