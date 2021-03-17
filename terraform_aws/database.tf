resource "aws_db_instance" "mantisdb-tf" {
  identifier           = "mantisdb-tf"
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mantisbtdb"
  username             = ""
  password             = ""
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name    = aws_db_subnet_group.mantis-subnet.name
  vpc_security_group_ids = [
      aws_security_group.mantis-sg.id
  ]
  publicly_accessible = true
  skip_final_snapshot = true
}
