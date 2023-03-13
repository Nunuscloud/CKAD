data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "cka_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "cka_master_1" {
  ami                         = data.aws_ami.server_ami.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.cka_sg_master.id]
  subnet_id                   = aws_subnet.cka_subnet_1.id
  associate_public_ip_address = true
  user_data                   = file("./master_user_data.sh")

  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "cka-master-1"
  }
}

resource "aws_instance" "cka_worker_1" {
  ami                         = data.aws_ami.server_ami.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.cka_sg_worker.id]
  subnet_id                   = aws_subnet.cka_subnet_2.id
  associate_public_ip_address = true
  user_data                   = file("./worker_user_data.sh")

  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "cka-worker-1"
  }
}

resource "aws_instance" "cka_worker_2" {
  ami                         = data.aws_ami.server_ami.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.cka_sg_worker.id]
  subnet_id                   = aws_subnet.cka_subnet_3.id
  associate_public_ip_address = true
  user_data                   = file("./worker_user_data.sh")

  root_block_device {
    volume_size = var.main_vol_size
  }
  tags = {
    Name = "cka-worker-2"
  }
}

resource "null_resource" "write_to_file" {
  triggers = {
    instance_id = aws_instance.cka_instance.id
  }

  provisioner "local-exec" {
    command = "printf '\n${self.public_ip}' >> aws_hosts"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sed -i '/^[0-9]/d' aws_hosts"
  }
}
