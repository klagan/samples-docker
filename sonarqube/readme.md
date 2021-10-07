# RUN sysctl -w vm.max_map_count=524288
# RUN sysctl -w fs.file-max=131072
# RUN ulimit -n 131072
# RUN ulimit -u 8192

- [ ] need to clean up templates, write documentation and parameterise better

These values need to present on the host
