# Kubernetes cluster example

##### PREREQUISITES. The following components should be installed to perform test demo:
1. ruby ('ruby -v' to check)
2. bundler ('gem install bundler' to install)
3. terraform (use appropriate package manager to install)
4. aws-cli (use appropriate package manager to install)
5. chef-run

##### 1. Clone repo:
```
$ git clone git@github.com:vsuzdaltsev/simple_kube_cluster.git
$ cd simple_kube_cluster
```
##### 2. Install mandatory tools:
```
$ install ruby, rake, terraform
```
##### 3. Set proper environment variables and export them:
```
$ vim aws_creds_example.txt      # fix api key values!!!!!!
$ source aws_creds_example.txt
```
##### 5. Set proper value for public key within variables.tf file:
```
$ "/Users/yaa/.ssh/id_rsa.pub" # !!!!!! <- works for me
```
##### 4. Run infrastructure creation:
```
$ rake infrastructure:create
```
##### 5. Run configuration:
```
$ rake chef:converge
```
##### 6. Destroy the created infrastructure:
```
$ rake infrastructure:create
```

This will do the following:
- create infrastructure described within terraform files (2 ec2 instances, vpc, some networking stuff)
- configure cluster - master/worker
- deploy test application (https://github.com/vsuzdaltsev/test_web_app)
- destroy infrastructure


