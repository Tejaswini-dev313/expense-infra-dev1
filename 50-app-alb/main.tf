module "app_alb" {
  source = "terraform-aws-modules/alb/aws"

  internal              = true
  name                  = "${local.resource_name}-app-alb" #expense-dev-app-alb
  vpc_id                = local.vpc_id
  subnets               = [local.private_subnet_id]
  security_groups       = [data.aws_ssm_parameter.app_alb_sg_id.value]
  create_security_group = false
  tags = merge(
    var.common_tags,
    var.app_alb_tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.app_alb.arn #amazon resource name and its unique id. it will generate when you create ALB
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Application ALB</h1>"
      status_code  = "200"
    }
  }
}

module "zone" {
  source    = "terraform-aws-modules/route53/aws"
  zone_name = var.zone_name
  records = {
    "*.app-dev" = {
      type = "A"
      alias = {
        name    = module.app_alb.dns_name
        zone_id = module.app_alb.zone_id
      }
      allow_overwrite = true
    }
  }
}