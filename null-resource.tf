resource "null_resource" "server" {

  count = var.environment == "prod" ? 3 : 1
  provisioner "file" {

    source      = "user-data.sh"
    destination = "/tmp/user-data.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("new.pem")

      host = aws_instance.public-server.*.public_ip[count.index]
    }

  }

  provisioner "remote-exec" {

    inline = [
      "sudo chmod 700 /tmp/user-data.sh",
      "sudo /tmp/user-data.sh",
      "sudo apt update",
      "sudo apt install jq unzip -y",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("new.pem")

      host = aws_instance.public-server.*.public_ip[count.index]
    }

  }

  provisioner "local-exec" {
    command = "echo 'Server created with IP: ${aws_instance.public-server.*.public_ip[count.index]}' >> creation_log.txt"
  }


}