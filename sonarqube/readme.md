# Set on host

- sysctl -w vm.max_map_count=524288
- sysctl -w fs.file-max=131072
- ulimit -n 131072
- ulimit -u 8192

## TODO
- [ ] need to clean up templates, write documentation and parameterise better
- [ ] https://techexpert.tips/sonarqube/sonarqube-docker-installation/![image](https://user-images.githubusercontent.com/244992/136503935-bdf49f89-50c4-4489-bd43-5d4e16717ed5.png)
