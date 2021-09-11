
# creates iam instance profile for ec2 instance
resource "aws_iam_instance_profile" "ec2ssm_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_policy.name
}
# creates iam role
resource "aws_iam_role" "ec2_policy" {
  name = "ec2_policy"
  assume_role_policy = file("ec2_policy.json")
}
# creates iampolicy for accesing ec2 instances 
resource "aws_iam_role_policy" "ssm_policy" {
  name = "ssm_policy"
  role = aws_iam_role.ec2_policy.id
  policy = file("ssm_policy.json")
}
