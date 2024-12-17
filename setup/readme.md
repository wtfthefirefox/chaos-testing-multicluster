# There is two path usage:
1. You are already have installed monitoring system, pods etc or you want to create a system based on two or more clusters on two or more hosts(for instance 1 host - 1 cluster). In this way you need to use this [instruction](separate/readme.md).
2. You want to try chaos system or you want to start a new project with chaos testing and you want to test it all locally. In this way you need to use this [instruction](local/readme.md).

# How i can setup three or more clusters?
Please, follow this [instruction](scaling/readme.md).

# Grafana access
1. Grafana password and login is `admin`.
2. All dashborads available at [folder](setup/common/monitoring/dasboards). To install dashboards follow this instruction:
   1. Open Dasboards section.
   2. Click `New` button and then `Import`.
   3. Copy value from chosen dasboard at [folder](setup/common/monitoring/dasboards) and paste it.
