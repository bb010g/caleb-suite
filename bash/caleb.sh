#!/bin/bash

if [[ -z "$1" ]] ; then echo 'Pick Omninet or EFnet' ; exit 1; fi
if [[ "$1" == "Omninet" ]] ; then network='saphira.irc.omnimaga.org' ; fi
if [[ "$1" == "EFnet" ]] ; then network='efnet.port80.se' ; fi
./CalebIRC.sh CalebBot "$network" 'caleb'
