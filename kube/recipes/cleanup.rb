# frozen_string_literal: true

bucket = node['s3_bucket']

%w[join.node.txt config].each do |s3_file|
  execute "rm #{s3_file} from bucket #{bucket}" do
    command "aws s3 rm s3://#{bucket}/#{s3_file}"

    only_if { system("aws s3 ls s3://#{bucket}/#{s3_file}") }
  end
end
