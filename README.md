# OS_fingerprinting
Scripts that can be used for information gathering on machines during IR.

Each directory contains a script that can be used. Naturally some of these commands do require some more specific parameters to be configured prior to running and you may need to run these as either `root` or with admin privilleges on Windows machines. Have some time? Checkout the directories for more specific and dedicated scripts that can be run and output to a file.

# Rapid fire
Only have a few minutes? Below is a quick referecne sheet for running commands to get an idea for what is being run on the system or what it might be used for. You can either save these to a file, or if you are using some termianl tool you could have that export/save the output of these commands to a file.

## Collect *Nix system information

### Running processes
```shell
ps -aux ps
```

### Last login information
```shell
lastlog
```

### Network status
```shell
netstat -atu 
```

### Network interfaces
```shell
ifconfig
```

### User accounts
```shell
cat /etc/passwd
```

## Examine these command outputs for anomalies

### Authentication logs
```shell
tail /var/log/auth.log
```

### Cron jobs logs
```shell
tail /var/log/cron
```

### HTTP server logs (if applicable)
```shell
tail /var/log/httpd
```

### SSH daemon logs
```shell
journalctl -u sshd
```

### Root user's cron jobs
```shell
crontab -u root -l
```

### Services status (for systemd systems)
```shell
systemctl --type=service --state=active
```
### Top processes by CPU usage
```shell
 top -b -n 1
```


## Collect info on Windows Systems
This could even be combined with my [SANS cheatsheet for Windows found here](https://gist.github.com/W00glin/62af880394fbf7eb2b4c74fc126950bb).
# Network connections
```powershell
"netstat -ao"
```

### User accounts
```powershell
"net users" 
```
#### Running tasks
```powershell
"tasklist" 
```

### Examine for anomalies

# Firewall rules
```powershell
"netsh advfirewall firewall show rule name=all"
```

# Scheduled tasks
```powershell
"Get-ScheduledTask" 
``
