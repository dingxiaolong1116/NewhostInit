#!/bin/bash
#��ѡ�����޸ĺ����з�������ʼ���ű�
PATH=/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

#1 �޸�root����
echo "FANGcang1688#"|passwd --stdin root

#2 ��ֹroot�û�Զ�̵�½ϵͳ
#sed  -i -e 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
#service sshd restart

#3 ��ֹnginx�û��˺���Ȩ�޵�½ϵͳ
if grep nginx /etc/passwd >/dev/null 2>&1 ;then
        usermod -s /sbin/nologin nginx
fi

#4 �޸�ϵͳĬ�ϵ�umaskֵ
sed -i -e 's/umask 022/umask 027/' /etc/bashrc

#5 ֻ��root����ִ������Ŀ¼����Ľű�
chmod -R 750  /etc/init.d/*

#6 ֻ��root���ܶ�ȡ
chmod 644 /etc/passwd
chmod 644 /etc/group
chmod 600 /etc/shadow
chmod 600 /etc/gshadow

#7 ��������ļ����ϲ��ɸ������ԣ��Ӷ���ֹ����Ȩ�û����Ȩ�ޡ� 
chattr +i /etc/passwd
chattr +i /etc/shadow
chattr +i /etc/group
chattr +i /etc/gshadow

#8 ����ϵͳ��Ϣ
cat /dev/null >/etc/issue
cat /dev/null >/etc/issue.net

#9 ���õ�½��ʱʱ��
echo "TMOUT=180">>/etc/profile

#10 ��ֹ�Ƿ����������
sed -i -e '/ctrlaltdel/s/^/#/' /etc/inittab

#11 ʱ���ʱ
echo "0 3 * * * /usr/sbin/ntpdate -u 193.167.10.97 >> /var/log/ntpdate.log 2>&1" >/var/spool/cron/root

#12 ��ʷ�������Ϊ0���˳�ϵͳʱ�Զ������ʷ����
sed -i 's@HISTSIZE=[0-9]*@HISTSIZE=0@' /etc/profile
source /etc/profile
echo "history -c" >>/root/.bash_logout

#13 set tcp_wrappers,ֻ�����������ҵĳ���IP����
echo "sshd:all:deny" > /etc/hosts.deny
echo "sshd:193.167.10.*,183.62.162.35,183.62.162.36,183.62.162.33" > /etc/hosts.allow

#14 set ssh
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

#15 �޸�snmpĬ�ϵ�������
if grep  'public$' /etc/snmp/snmpd.conf;then
        sed -i  -e   's/public$/qwertzxcvb/g' /etc/snmp/snmpd.conf
        service snmpd restart
fi

#16 �رղ���Ҫ�ķ���
cat >/tmp/service.conf<<EOF
microcode_ctl
gpm
kudzu
amd
nfs
apmd
arpwatch
autofs
automount
bootparamd
dhcpd
gated
httpd
inetd
innd
linuxconf
lpd
mars-nwe
mcserv
named
netfs
samba
nfs
nscd
portmap
postgresql
rstatd
ruserd
rwalld
whod
sendmail
smb
squid
xfs
ypbind
yppasswdd
pserv
identd
bluetooth
ibmasm
ip6tables
lm_sensors
saslauthd
vncserver
nfslock
rawdevices
svnserve
acpid
capi
cpuspeed
hidd
ip6tables
cups
dund
haldaemon
isdn
irda
netplugd
pand
conman
lvm2-monitor
mdmonitor
restorecond
talk
finger
telnet
EOF

while read service other
do
        if chkconfig --list|grep ${service};then
        service ${service} stop
        chkconfig ${service} off
        fi
done</tmp/service.conf

#17 �ں˲����Ż�
true > /etc/sysctl.conf
cat >> /etc/sysctl.conf << EOF
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_local_port_range = 1024 65535
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_tw_recycle = 1 
net.ipv4.tcp_tw_reuse = 1 
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_window_scaling = 0
net.ipv4.tcp_sack = 0
net.core.netdev_max_backlog = 30000
net.ipv4.tcp_no_metrics_save=1
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_keepalive_time=1200 
net.nf_conntrack_max = 6553600
EOF
/sbin/sysctl -p

#18 ϵͳ��Դ����
cat > /etc/security/limits.conf << EOF
*       soft nofile 65535
*       hard nofile 65535
root   soft    nproc   65535
root   soft    nproc   65535
oracle   hard    nproc   65535
oracke   hard    nproc   65535
nginx   hard    nproc   65535
nginx   hard    nproc   65535
EOF