resource "aws_key_pair" "example-key-pair" {
  key_name   = "${var.identity}-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "master" {
  ami                    = var.wb_ami
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.example-key-pair.id
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.sgweb.id]

  associate_public_ip_address = true

  source_dest_check    = false
  user_data            = file("install.sh")
  iam_instance_profile = aws_iam_instance_profile.test_profile.name

  tags = merge(map("Name", "master"), var.default_tags)
}

resource "aws_instance" "worker_one" {
  ami                    = var.wb_ami
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.example-key-pair.id
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.sgweb.id]

  associate_public_ip_address = true

  source_dest_check    = false
  user_data            = file("install.sh")
  iam_instance_profile = aws_iam_instance_profile.test_profile.name

  tags = merge(map("Name", "worker_one"), var.default_tags)
}

resource "aws_s3_bucket" "yaa-test" {
  bucket = "yaa-test"
  acl    = "private"

  tags = merge(map("Name", "yaa_test_bucket"), var.default_tags)
}

resource "aws_iam_role" "test_role" {
  name = "test_role"
  path = "/"

  tags = merge(map("Name", "yaa_test_role"), var.default_tags)

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "yaa_test_profile"
  role = aws_iam_role.test_role.name
}

resource "aws_iam_role_policy" "test_policy" {
  name = "yaa_test_policy"
  role = aws_iam_role.test_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_vpc_endpoint" "s3-yaa-test" {
  vpc_id       = aws_vpc.kube.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = [aws_route_table.public-rt.id]
}