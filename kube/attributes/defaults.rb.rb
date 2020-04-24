# frozen_string_literal: true

default['s3_bucket']                 = 'yaa-test'
default['kubectl']['config']['path'] = '/home/ubuntu/.kube/config'

default['master']['init_log']              = 'join.node.txt'
default['master']['helm_install_postgres'] = 'helm install postgres bitnami/postgresql --set image.repository=postgres --set image.tag=10.6 --set persistence.size=512M,persistence.storageClass=manual,persistence.mountPath=/mnt/data --set postgresqlPassword=yaa,postgresqlDatabase=yaa,postgresqlDataDir=/mnt/data > db_install.log'

default['kubernetes']['pod_cidr']               = '10.244.0.0/16'
default['kubernetes']['persistent_volume_data'] = '/mnt/data'
default['kubernetes']['deployments']['web-api'] = '/home/ubuntu/web-api.yml'
