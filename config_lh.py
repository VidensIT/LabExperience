x = [0,1,2,3,4,5,6]
specific_route = '40.91.216.117/32'
ips = ['40.91.216.117',
       '40.127.198.46',
       '137.117.45.133',
       '52.179.213.230',
       '40.85.250.63',
       '51.140.44.69',
       '65.52.206.156']

def ip_list():
    outputip = []
    for y in x:
        outputip.append('10.{}.1.42'.format(str(y)))
    return outputip

for y in x:
    print "Config host {}:".format(str(y))
    print 'ssh -i ./id_rsa lab@' + ips[y]
    print ""
    print "sudo route add -net 10.0.0.0/8 gw 10.{}.1.41 dev eth1".format(str(y))
    print "sudo ifconfig lo:1 10.{}.100.1 netmask 255.255.255.0 up".format(str(y))
    print "sudo route add -host {} gw 10.{}.2.1 dev eth0".format(specific_route, str(y))
    print "sudo route add -net 0.0.0.0/0 gw 10.{}.1.41 dev eth1".format(str(y))
    print "sudo route del -net 0.0.0.0/0 gw 10.{}.2.1 dev eth0".format(str(y))
    print "rm iplist"
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


ab = 0
for ip in ips:
    print '{} ssh -i ./id_rsa lab@'.format(ab) + ip
    ab += 1