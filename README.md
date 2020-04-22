# Kubernetes cluster example

##### PREREQUISITES. The following components should be installed to perform test demo:
1. ruby ('ruby -v' to check)
2. rake ('gem install rake' to install)
3. terraform (use appropriate package manager to install)
4. aws-cli (use appropriate package manager to install)
5. chef-run (a part of chef-workstation package, use appropriate package manager to install)

##### 1. Clone repo:
```
$ git clone git@github.com:vsuzdaltsev/simple_kube_cluster.git
$ cd simple_kube_cluster
```
##### 2. Install mandatory tools:
```
$ install ruby, rake, terraform, chef-workstation
```
##### 3. Set proper environment variables and export them:
```
$ vim aws_creds_example.txt      # fix api key values!!!!!!
$ source aws_creds_example.txt
```
##### 4. Set proper value for public key path within variables.tf (line 23) file:
```
$ "/Users/yaa/.ssh/id_rsa.pub"   # <- works for me; fix key path!!!!!! 
```
##### 5. List existing tasks:
```
$ rake -T
>>
rake chef:converge           # converge all nodes
rake infrastructure:create   # create infrastructure
rake infrastructure:destroy  # destroy infrastructure
rake running_pods:kill       # kill running pods within cluster
```
##### 6. Run infrastructure creation:
```
$ rake infrastructure:create
```
##### 7. Run configuration:
```
$ rake chef:converge
```
##### 8. Open app in browser (see converge output for url)
##### 9. Enter some input and check the result
##### 10. Kill running pods:
```
$ rake running_pods:kill
```
##### 11. Go to browser, wait a bit and check if app running and presenting persistent data
##### 12. Destroy the created infrastructure:
```
$ rake infrastructure:destroy
```

This will do the following:
- create infrastructure described within terraform files (2 ec2 instances, vpc, some networking stuff)
- configure cluster - master/worker
- deploy test application (https://github.com/vsuzdaltsev/test_web_app)
- notify user about the application uri
- destroy infrastructure

