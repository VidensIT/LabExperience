x = [0,1,2,3,4,5,6]

def ip_list():
    outputip = []
    for y in x:
        outputip.append('10.{}.1.42'.format(str(y)))
    return outputip

for y in x:
    print "Config host {}:".format(str(y))
    print ""
    print "sudo route add -net 10.0.0.0/8 gw 10.{}.1.41 dev eth1".format(str(y))
    print "sudo ifconfig lo:1 10.{}.100.1 netmask 255.255.255.0 up".format(str(y))
    for a in ip_list():
        print "echo '{}' >> iplist".format(a)
    print "fping < iplist"
    print "wget 10.0.1.42"
    print "iperf -c 10.0.1.42"
    print ""

for y in x:
    rg = 'tj_VELO_vVCE_RG_CEVA_GROUP{}'.format(str(y))
    host = 'tjLHVCE{}'.format(str(y))
    print "az vm list-ip-addresses --resource-group {} --name {} --output table".format(rg, host)

ips = ['40.118.47.94',
       '40.115.114.194',
       '40.76.15.158',
       '137.116.70.29',
       '40.85.240.169',
       '51.140.45.23',
       '65.52.5.204']

for ip in ips:
    print 'ssh -i ./id_rsa lab@' + ip