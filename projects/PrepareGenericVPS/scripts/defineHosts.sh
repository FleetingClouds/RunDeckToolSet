declare SHORT_NAME=`echo $1 | cut -d "." -f1 -`

cat > /etc/hosts <<EOF
127.0.0.1	$SHORT_NAME	localhost.localdomain	localhost
127.0.1.1	$SHORT_NAME

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

hostname $SHORT_NAME

# sudo /etc/init.d/networking restart

sudo ifdown venet0:0  && sudo ifup venet0:0 


