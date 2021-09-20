# Offline preparation
This process is written assuming full air gap, meaning that the system with internet access will not have access to TKG or the private image registry. </br>
Before starting this procedure ensure that docker-ce and git have been installed on the Linux machine use to drive this process. </br>
Clone this repo onto the Linux machine `git clone https://github.com/laidbackware/tkg-tools.git` </br>

## Process
1. [download binaries](tools/README.md)
2. [collect terraform providers](terraform/README.md)
3. [pull and export kind docker image](kind/README.md)
4. [download the vmware software](vmware-binaries/README.md)
5. [pull and export kind docker image](vmware-images/README.md)