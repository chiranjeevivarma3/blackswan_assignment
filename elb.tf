# creates elastic ip to Network load balancer
resource "aws_eip" "eip_nlb" {
  tags    = {
    Name  = "test-network-lb-eip"
  }
}
# creates Network load balancer
resource "aws_lb" "demo" {
  name               = "demo-elb"
  load_balancer_type = "network"
  internal           = false
  subnet_mapping {
    subnet_id     = aws_subnet.public.id
    allocation_id = aws_eip.eip_nlb.id
  }
}
# add load balancer listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.demo.arn
  port              = "443"
  protocol          = "TLS"
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.webserver-tg.arn

    }
}
# creates targetgroup for load balancer
resource "aws_lb_target_group" "webserver-tg" {
  name     = "demo-lb-tg"
  port     = 80
  protocol = "TCP"
  target_type="instance"
  vpc_id   = aws_vpc.demo.id
}
# attaches ec2 instace to Network load balancer
resource "aws_lb_target_group_attachment" "ec2attach" {
  target_group_arn = aws_lb_target_group.webserver-tg.arn
  target_id        = aws_instance.webserver.id
  port             = 80
}
