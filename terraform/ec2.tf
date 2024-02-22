provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"

  tags = {
    Name = "Python-Hello-World-Instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y python3-pip
              pip3 install Flask
              cd /home/ubuntu
              echo '
              def main():
  print("Hello World!")
if __name__== "__main__":
  main()
}