#!/bin/sh
parallel -u --xapply ./CalebLnk.sh {1} {2} {3} {4} ::: 'efnet.port80.se' 'saphira.irc.omnimaga.org' ::: 'caleb' 'caleb' ::: 'saphira.irc.omnimaga.org' 'efnet.port80.se' ::: 'caleb' 'caleb'
