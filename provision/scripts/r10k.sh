#!/bin/bash

if [[ -e '/opt/puppet/bin/r10k' ]]
then
    /opt/puppet/bin/r10k deploy environment -pv
fi
