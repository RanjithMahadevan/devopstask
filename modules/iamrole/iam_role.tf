
data "template_file" "policy" {
  template = file("${var.policy}")
}

resource "aws_iam_role" "dock_role" {
  name               = var.ec2_role_name
  assume_role_policy = data.template_file.policy.rendered
  tags = {
    Name = "var.ec2_role_name"
  }
}

#resource "aws_iam_instance_profile" "dock_ec2_profile" {
#  name = "dock_profile"
#  role = aws_iam_role.dock_role.name
#}

#resource "aws_iam_role_policy" "iam_ec2_role_policy" {
#  name       = "s3dock_policy"
#  role       = aws_iam_role.dock_role.id
#  policy     = data.template_file.iam_ec2_role_policy.rendered
#  depends_on = [aws_s3_bucket.dock]
#}

