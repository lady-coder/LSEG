package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

var awsRegion = "eu-west-2"

var moduleParameters map[string]interface{} = map[string]interface{}{
	"environment":      "poc",
	"region":           awsRegion,
	"business_unit":    "lch",
	"application_name": "sno",
	"application_id":   "APP-12345",
	"cost_centre":      "cc12345",
	"project_code":     "12345-123",
	"resource_type":    "s3",
	"additional_names": []string{
		"joe",
		"bloggs",
	},
}

type tagLabel struct {
	Environment           string            `json:"environment"`
	Region                string            `json:"region"`
	BusinessUnit          string            `json:"business_unit"`
	ApplicationName       string            `json:"application_name"`
	ApplicationId         string            `json:"application_id"`
	CostCentre            string            `json:"cost_centre"`
	ManagedBy             string            `json:"managed_by"`
	ProjectCode           string            `json:"project_code"`
	DataClassification    string            `json:"data_classification"`
	Automation            string            `json:"automation"`
	ResourceType          string            `json:"resource_type"`
	ServiceName           string            `json:"service_name"`
	AdditionalNames       []string          `json:"additional_names"`
	AdditionalTags        map[string]string `json:"additional_tags"`
	CodeRepo              string            `json:"code_repo"`
	ChangeNameFormatOrder []string          `json:"change_name_format_order"`
	Delimeter             string            `json:"delimeter"`
	NameUseCase           string            `json:"name_use_case"`
	Enabled               bool              `json:"enabled"`
}

func TestExampleLablesIT(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/complete",
		Upgrade:      true,
		Vars:         moduleParameters,
	}

	terraform.InitAndApply(t, terraformOptions)

	expectedResourceName1 := "lch-sno-poc-s3-joe-bloggs"
	expectedResourceName2 := "lch+sno+poc+s3+joe+bloggs"
	expectedResourceName3 := "LCH+SNO+POC+S3+JOE+BLOGGS"
	expectedResourceName4 := "LCH|SNO|POC|S3|JOE|BLOGGS"

	label1 := terraform.OutputMap(t, terraformOptions, "label1")
	label2 := terraform.OutputMap(t, terraformOptions, "label2")
	label3 := terraform.OutputMap(t, terraformOptions, "label3")
	label4 := terraform.OutputMap(t, terraformOptions, "label4")

	assert.Equal(t, expectedResourceName1, label1["name"])
	assert.Equal(t, expectedResourceName2, label2["name"])
	assert.Equal(t, expectedResourceName3, label3["name"])
	assert.Equal(t, expectedResourceName4, label4["name"])

}
