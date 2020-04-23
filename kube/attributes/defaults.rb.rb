# frozen_string_literal: true

default['s3_bucket']                       = 'yaa-test'
default['master']['init_log']              = 'join.node.txt'
default['master']['helm_install_postgres'] = 'helm install postgres bitnami/postgresql --set image.repository=postgres --set image.tag=10.6 --set persistence.size=512M,persistence.storageClass=manual,persistence.mountPath=/mnt/data --set postgresqlPassword=yaa,postgresqlDatabase=yaa,postgresqlDataDir=/mnt/data > db_install.log'
