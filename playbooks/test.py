from haproxystats import HAProxyServer
haproxy = HAProxyServer('10.26.3.126:9000/stats', 'admin', 'haproxy')
if haproxy.failed == True:
  print("HAProxy is unavaliable")
for b in haproxy.listeners:
    if b.status == "UP":
        print("OK")
        print('%s: %s' % (b.name, b.status))


