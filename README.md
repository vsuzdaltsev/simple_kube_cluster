# Kubernetes cluster example

##### PREREQUISITES. The following components should be installed to perform test demo:
1. ruby ('ruby -v' to check)
2. rake ('gem install rake' to install)
3. terraform (use appropriate package manager to install)
4. chef-run (a part of chef-workstation package, use appropriate package manager to install)
5. you have to provide key pair which will be use to configure VMs (see step 3 and step 4)

##### 1. Clone repo:
```
$ git clone git@github.com:vsuzdaltsev/simple_kube_cluster.git
$ cd simple_kube_cluster
```
##### 2. Install mandatory tools:
```
install ruby, rake, terraform, chef-workstation
```
##### 3. Set proper environment variables and export them:
```
$ vim aws_creds_example.txt      # fix api key values!!!!!!
$ source aws_creds_example.txt
```
##### 4. Set proper value for public key path within variables.tf (line 23) file:
```
"/Users/yaa/.ssh/id_rsa.pub"   # <- works for me; fix key path!!!!!!
```
##### 5. Set proper value for private key path within Rakefile (line 3):
```
private_key = '~/.ssh/id_rsa'   # <- works for me; fix key path!!!!!!
```
##### 6. Explore existing tasks:
```
$ rake -T                    # automated cluster/application deployment
>>
rake chef:converge           # converge all nodes
rake infrastructure:create   # create infrastructure
rake infrastructure:destroy  # destroy infrastructure
rake running_pods:kill       # kill running pods within cluster
```
```
$ rake -T --all                      # all tasks can be run one by one
>>
rake chef:cleanup_s3                 #
rake chef:converge                   # converge all nodes
rake chef:deployment                 # <- deploy test application (application itself & postgres)
rake chef:run_on_master_custom       # <- Configure master node. Create and configure kubernetes cluster
rake chef:run_on_master_default      # <- Configure master node. Install appropriate tools
rake chef:run_on_worker_one_custom   # <- Configure worker node. Join to existing cluster
rake chef:run_on_worker_one_default  # <- Configure worker node. Install appropriate tools
rake infrastructure:create           # create infrastructure <- Provision resources within the aws
rake infrastructure:destroy          # destroy infrastructure <- Destroy resources within the aws
rake notify:where_app_endpoint       # <- Notify deployed app uri in the cloud
rake running_pods:kill               # kill running pods within cluster
```
##### 7. Run infrastructure creation:
```
$ rake infrastructure:create
```
##### 8. Run configuration:
```
$ rake chef:converge
```
##### 9. Open app in browser (see converge output for url)
##### 10. Enter some input and check the result
##### 11. Kill all running pods - application & db:
```
$ rake running_pods:kill
```
##### 12. Go to browser. Wait a bit wlile kubernetes recovering pods. Refresh the page to check if app is running and presenting persistent data
##### 13. Destroy the created infrastructure:
```
$ rake infrastructure:destroy
```
---
Rake tasks described above can at whole do the following:
- create infrastructure described within terraform files (2 ec2 instances, vpc, some networking stuff)
- configure cluster - master/worker
- deploy test application (https://github.com/vsuzdaltsev/test_web_app)
- notify user about the application uri
- delete pods running on the cluster
- destroy infrastructure

NB: use something like the following to access nodes created with the automation tool:

```
$ ssh ubuntu@$(terraform output -json | jq '.master_one_public_ip.value' | tr -d '\"') # <- master node

$ ssh ubuntu@$(terraform output -json | jq '.worker_one_public_ip.value' | tr -d '\"') # <- worker node
```

