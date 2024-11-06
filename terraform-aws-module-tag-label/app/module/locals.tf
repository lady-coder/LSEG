locals {

  defaults = {
    default_change_name_format_order = [
      "BusinessUnit",
      "ApplicationName",
      "Environment",
      "AWSResourceType",
      "AdditionalNames",
    ]
    name_use_case = "none"
    delimeter     = "-"
  }

  _change_name_format_order = length(var.change_name_format_order) == 0 ? try(var.tag_me.change_name_format_order, []) : var.change_name_format_order
  input = {
    enabled = var.enabled == null ? try(var.tag_me.enabled, true) : var.enabled

    business_unit            = try(var.business_unit, null) == null ? var.tag_me.business_unit : var.business_unit
    environment              = try(var.environment, null) == null ? var.tag_me.environment : var.environment
    application_name         = try(var.application_name, null) == null ? var.tag_me.application_name : var.application_name
    application_id           = try(var.application_id, null) == null ? var.tag_me.application_id : var.application_id
    cost_centre              = try(var.cost_centre, null) == null ? var.tag_me.cost_centre : var.cost_centre
    managed_by               = try(var.managed_by, null) == null ? var.tag_me.managed_by : var.managed_by
    project_code             = try(var.project_code, null) == null ? var.tag_me.project_code : var.project_code
    data_classification      = try(var.data_classification, null) == null ? var.tag_me.data_classification : var.data_classification
    automation               = try(var.automation, null) == null ? var.tag_me.automation : var.automation
    resource_type            = try(var.resource_type, null) == null ? var.tag_me.resource_type : var.resource_type
    service_name             = try(var.service_name, null) == null ? var.tag_me.service_name : var.service_name
    region                   = try(var.region, null) == null ? var.tag_me.region : var.region
    code_repo                = lower(replace(var.code_repo == null ? var.tag_me["code_repo"] : var.code_repo, "/^[\\w:]+(//)+?|[.]git$/", ""))
    name_use_case            = try(var.name_use_case, null) == null ? var.tag_me.name_use_case : var.name_use_case
    additional_names         = compact(distinct(concat(coalesce(try(var.tag_me.additional_names, [])), coalesce(var.additional_names, []))))
    delimeter                = var.delimeter == null ? try(var.tag_me.delimeter, local.defaults.delimeter) : var.delimeter
    change_name_format_order = local._change_name_format_order == [] ? local.defaults.default_change_name_format_order : coalescelist(local._change_name_format_order, local.defaults.default_change_name_format_order)
    additional_tag_map       = merge(try(var.tag_me.additional_tag_map, {}), var.additional_tag_map)
    additional_tags          = merge(try(var.tag_me.additional_tags, {}), var.additional_tags)
  }

  props = {
    poc = {
      envtype = "dev"
      subtype = "poc"
    },
    preprod = {
      envtype = "qa"
      subtype = "staging"
    },
    prod = {
      envtype = "production"
      subtype = "live"
    }
  }

  # Generate tags

  mandatory_tags = {
    Name                   = local.id
    BusinessUnit           = upper(local.input["business_unit"])
    ApplicationName        = upper(local.input["application_name"])
    ApplicationId          = upper(local.input["application_id"])
    CostCentre             = upper(local.input["cost_centre"])
    ProjectCode            = upper(local.input["project_code"])
    DataClassification     = local.input["data_classification"]
    Automation             = local.input["automation"]
    Environment            = upper(local.input["environment"])
    AWSResourceType        = upper(local.input["resource_type"])
    Region                 = upper(local.input.region)
    CodeRepo               = local.input["code_repo"]
    ManagedBy              = local.input["managed_by"]
    mnd-applicationid      = lower(local.input["application_id"])
    mnd-applicationname    = lower(local.input["application_name"])
    mnd-supportgroup       = "tobeconfirmed"
    mnd-projectcode        = lower(local.input["project_code"])
    mnd-costcentre         = lower(local.input["cost_centre"])
    mnd-envtype            = lookup(local.props, local.input["environment"], "notapplicable").envtype
    mnd-envsubtype         = lookup(local.props, local.input["environment"], "notapplicable").subtype
    mnd-dataclassification = "highlyrestricted"
    mnd-baseimagename      = "notapplicable"
    mnd-owner              = "aws-${lower("${local.input["business_unit"]}-${local.input["application_name"]}-${local.input["environment"]}")}@lseg.com"
    #mnd-lifecycle      = "highlyrestricted"#
    App_ID                 = lower(local.input["application_id"])
    Application_name       = lower(local.input["application_name"])

  }


  mandatory_tag_keys = toset(keys(local.mandatory_tags))

  default_tags = merge(local.mandatory_tags, local.input.additional_tags)

  tags = { for l, v in local.default_tags : l => v if v != "" }

  tags_as_list_of_maps = flatten([
    for key in keys(local.tags) :
    merge(
      {
        key   = key
        value = local.tags[key]
      }, local.input.additional_tag_map
    )
  ])

  id_map = {
    BusinessUnit    = local.input["business_unit"]
    ApplicationName = local.input["application_name"]
    Environment     = local.input["environment"]
    AWSResourceType = local.input["resource_type"]
    AdditionalNames = join(local.delimeter, local.input["additional_names"])
  }

  delimeter = local.input.delimeter == null ? local.defaults.delimeter : local.input.delimeter
  id_label  = [for l in local.input.change_name_format_order : local.id_map[l] if length(local.id_map[l]) > 0]
  id        = local.input.name_use_case == "none" || local.input.name_use_case == null ? join(local.delimeter, local.id_label) : local.input.name_use_case == "upper" ? upper(join(local.delimeter, local.id_label)) : lower(join(local.delimeter, local.id_label))

  output_vars = {
    Enabled            = local.input.enabled
    Name               = local.id
    Delimeter          = local.input["delimeter"]
    NameUseCase        = local.input["name_use_case"]
    BusinessUnit       = local.input["business_unit"]
    ApplicationName    = local.input["application_name"]
    ApplicationId      = local.input["application_id"]
    AdditionalNames    = local.input["additional_names"]
    CostCentre         = local.input["cost_centre"]
    ProjectCode        = local.input["project_code"]
    DataClassification = local.input["data_classification"]
    Automation         = local.input["automation"]
    Environment        = local.input["environment"]
    AWSResourceType    = local.input["resource_type"]
    CodeRepo           = local.input["code_repo"]
    ManagedBy          = local.input["managed_by"]
    Region             = local.input["region"]
    AdditionalTagMap   = local.input.additional_tag_map
    AdditionalTags     = local.input.additional_tags
  }
  input_labels = merge({ for k, v in local.output_vars : lower(k) => v if lower(k) != "name" }, { "region" : var.region })
}

