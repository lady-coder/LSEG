# AWS Terraform Tagging Module 

Terraform module designed to generate consistent label names and tags for AWS resources.
 
This module is used to implement a strict naming and tagging convention for AWS resources.

A label or name follows the following convention: `{environment}-{application}-{role}-{instance_names}`. The delimiter used is, "-" but this can be changed using the module paramter, `delimeter`.
The `additional_names` parameter is optional and is used to augment the common naming strategy. If `additional_names` is not used then the naming label is `{environment}-{name}-{application}`.  

It's recommended to use one `terraform-module-tag-label` module for every unique resource of a given resource type.

For example, if you have 10 instances, there should be 10 different labels.
However, if you have multiple different kinds of resources (e.g. instances, security groups, file systems, and elastic ips), then they can all share the same label assuming they are logically related.  This module is flexible enough to allow for a good degree of flexibility around the different requirements and challenges faced within a businesses tagging/naming strategy.

## Tagging Specification
This specification is adopted from [Cloud Account Naming and Tagging Standards](https://lsegdocs.lseg.stockex.local/display/CLOUD/Cloud+Account+Naming+and+Tagging+Standards)

## Usage

### Simple Example
```hcl
module "label" {
  source           = "git@github.com:ChineduUzoka/terraform-module-tag-label.git//modules"
  environment      = "sandbox"
  application_name = "dso"
  resource_type    = "s3"
  component        = ""
  region           = var.region
  additional_names = [
    "spark"
  ]
  additional_tags = {
    CostCode    = "3454-495905"
  }
}
```

```hcl
module "label" {
  source           = "git@github.com:ChineduUzoka/terraform-module-tag-label.git//modules"
  application_name = "dso"
  resource_type    = "s3"
  component        = ""
  additional_names = ["EC2"]

  additional_tags = {
    CostCode    = "3454-495905"
  }

  additional_tags_map {
    "propagate_at_launch" = "1"
  }
}
```

This will create an output called id with the value of dso-s3-EC2

Reference the label when creating a vm:

```hcl
resource "aws_instance" "prod_bastion_public" {
  instance_type = "t1.micro"
  name          = module.label.name
  tags          = "module.label.tags"
}
```

### Advanced Example

Heres another example using the attribute 'tags_as_list_of_maps'

```hcl
################################
# terraform-module-tag-label example #
################################
module "label" {
  source           = "git@github.com:ChineduUzoka/terraform-module-tag-label.git//modules"
  application_name = "dso"
  resource_type    = "s3"
  component        = ""
  additional_names = ["EC2"]
  gitrepo           = "github.com:contino/edp-tf-common-modules.git"

  additional_tags = {
    CostCode    = "3454-495905"
  }

  additional_tag_map {
    "propagate_at_launch" = "1"
  }
}

#######################
# Launch template     #
#######################
resource "aws_launch_template" "default" {
  # terraform-module-tag-label example used here: Set template name prefix
  name_prefix                           = "${module.label.id}-"
  image_id                              = data.aws_ami.amazon_linux.id
  instance_type                         = "t2.micro"
  instance_initiated_shutdown_behavior  = "terminate"

  vpc_security_group_ids                = [data.aws_security_group.default.id]

  monitoring {
    enabled                             = false
  }
  # terraform-module-tag-label example used here: Set tags on volumes
  tag_specifications {
    resource_type                       = "volume"
    tags                                = module.label.tags
  }
}

######################
# Autoscaling group  #
######################
resource "aws_autoscaling_group" "default" {
  # terraform-module-tag-label example used here: Set ASG name prefix
  name_prefix                           = "${module.label.id}-"
  vpc_zone_identifier                   = [data.aws_subnet_ids.all.ids]
  max_size                              = "1"
  min_size                              = "1"
  desired_capacity                      = "1"

  launch_template = {
    id                                  = aws_launch_template.default.id
    version                             = "$$Latest"
  }

  # terraform-module-tag-label example used here: Set tags on ASG and EC2 Servers
  tags                                  = module.label.tags_as_list_of_maps
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_names"></a> [additional\_names](#input\_additional\_names) | n/a | `list(string)` | `[]` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags which are added to the resource (e.g. `{"Confidential" : "secret"}` | `map(string)` | `{}` | no |
| <a name="input_additional_tags_map"></a> [additional\_tags\_map](#input\_additional\_tags\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `additional_tags`. | `map(string)` | `{}` | no |
| <a name="input_application_id"></a> [application\_id](#input\_application\_id) | Used to identify disparate resource that are related to a specific application, managed by CTO in Saleforce | `string` | `null` | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | This is the abbreviated application name as defined by the Cloud Account Naming and Tagging Standards document<br>`https://lsegdocs.lseg.stockex.local/x/Cv7cAQ` | `string` | n/a | yes |
| <a name="input_automation"></a> [automation](#input\_automation) | n/a | `string` | `"PLACEHOLDER"` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | value | `string` | `null` | no |
| <a name="input_change_name_format_order"></a> [change\_name\_format\_order](#input\_change\_name\_format\_order) | Used to change the order of the id/label | `list(string)` | `[]` | no |
| <a name="input_code_repo"></a> [code\_repo](#input\_code\_repo) | Name of the projects git repository and git post-fix excluding the protocol<br>e.g. github.com:joeblogs/terraform-aws-joeblogs-bastion | `string` | `""` | no |
| <a name="input_cost_centre"></a> [cost\_centre](#input\_cost\_centre) | Identifies part of LSEG that should be charged for the tagged AWS resources | `string` | n/a | yes |
| <a name="input_data_classification"></a> [data\_classification](#input\_data\_classification) | Used to enable data classification of the data stored within AWS resources that support data storage | `string` | `"Internal"` | no |
| <a name="input_delimeter"></a> [delimeter](#input\_delimeter) | This is a one character delimeter used to separate the various elements that make up the `name` tag | `string` | `"-"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'prod', 'stage', 'test', 'dev' | `string` | n/a | yes |
| <a name="input_managed_by"></a> [managed\_by](#input\_managed\_by) | Used to idenitify resources created by CET | `string` | `"Terraform"` | no |
| <a name="input_name_use_case"></a> [name\_use\_case](#input\_name\_use\_case) | This is primarily used to change the case of a resources name | `string` | `null` | no |
| <a name="input_project_code"></a> [project\_code](#input\_project\_code) | Project code is the numerical value used to identify Projects in Oracle Financials | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The location which the resource that the label is applied to is located | `string` | `""` | no |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | This is the abbreviated name of the resource being labelled ie vm, cloudsql, bucket | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Describe the function of a resource e.g. WebServer, MessageBroker, Database | `string` | `""` | no |
| <a name="input_tag_me"></a> [tag\_me](#input\_tag\_me) | n/a | `any` | <pre>{<br>  "additional_names": [],<br>  "additional_tags": {},<br>  "additional_tags_map": {},<br>  "application_id": null,<br>  "application_name": null,<br>  "automation": null,<br>  "business_unit": null,<br>  "change_name_format_order": [],<br>  "code_repo": null,<br>  "cost_centre": null,<br>  "data_classification": null,<br>  "delimeter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "managed_by": null,<br>  "name_use_case": null,<br>  "project_code": null,<br>  "region": null,<br>  "resource_type": null,<br>  "service_name": null<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_annotate"></a> [annotate](#output\_annotate) | Allows to copy module label inputs into other module labels via `tag_me` variable |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | n/a |
| <a name="output_input"></a> [input](#output\_input) | n/a |
| <a name="output_name"></a> [name](#output\_name) | Disambiguated ID |
| <a name="output_output_vars"></a> [output\_vars](#output\_output\_vars) | Input vars used to run the module some of which have been modified. Can be used in other modules |
| <a name="output_tags"></a> [tags](#output\_tags) | Normalized tag map |
| <a name="output_tags_as_list_of_maps"></a> [tags\_as\_list\_of\_maps](#output\_tags\_as\_list\_of\_maps) | Additional tags as a list of maps, which can be used by several AWS resources<br>e.g. Auto Scaling Groups |

