#!/bin/bash

if [[ -z "$1" ]] ; then echo 'Pick Freenode or Omninet or EFnet and a channel' ; exit 1; fi
if [[ "$1" == "Freenode" ]] ; then network='irc.freenode.net' ; fi
if [[ "$1" == "Omninet" ]] ; then network='saphira.irc.omnimaga.org' ; fi
if [[ "$1" == "EFnet" ]] ; then network='efnet.port80.se' ; fi
./CalebIRC.sh CalebBot "$network" "$2"
