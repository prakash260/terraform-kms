# AWS KMS Key

AWS Key Management Service (KMS) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications. This component creates a KMS key that is used to encrypt data across the platform.

It creates:

- _KMS key_: Resource which creates KMS key
- _KMS key policy_: Key policies which permits cross account access, access through AWS principles and AWS services based on some conditions and input variables

## Pre-requisites

**IMPORTANT NOTE**

  1. Required version of Terraform is mentioned in [meta.tf](meta.tf).

  2. Go through [var.tf](var.tf) for understanding each terraform variable before running this component.

**How to use this component**

### example using service key type
```   
   module "logs_kms" {

          source      = "git@gitlab.com:bhp-cloudfactory/aws-components/terraform-aws-kms-key.git?ref=5.0.1"

          key_type    = "service"

          description = "Used to encrypt log aggregation resources"

          alias_name  = local.kms_alias_name

          custom_tags = var.custom_tags

          service_key_info = {

                "aws_service_names"  = [format("ec2.%s.amazonaws.com", data.aws_region.current.name)]

                "caller_account_ids" = [data.aws_caller_identity.current.account_id]

            }
        }
```

### example using direct key type
```
  module "sns_key" {

        source = "git@gitlab.com:bhp-cloudfactory/aws-components/terraform-aws-kms-key.git?ref=5.0.1"


        alias_name           = "app-alarm-sns-key"

        append_random_suffix = true

        key_type             = "direct"

        principal_type       = "Service"

        description          = "Used to encrypt sns data"

        custom_tags          = var.custom_tags


        direct_key_info = {

              "allow_access_from_principals" = ["sns.amazonaws.com", "cloudwatch.amazonaws.com"]

          }

      }
```
<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.7.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.7.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Modules

No modules.

## Inputs

| **Name** | **Description** | **Type** | **Default** | **Required** |
| --- | --- | --- | --- | --- |
| alias_name | Name for the kms key alias. A random string will be appended depending on the append_random_suffix variable | string | n/a | yes |
| description | The description to give to the key | string | n/a | yes |
| key_type | Indicate which kind of key to create: service for key used by services; direct for other keys. Must provide service_key or direct_key maps depending on the type | string | n/a | yes |
| append_random_suffix | Append a random string to the alias name. Default: true (yes) | bool | true | no |
| charge_code | The code for applying charge code billing logic to the resources | string |  | no |
| custom_tags | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys | map(any) | {} | no |
| deletion_window | Number of days before a key actually gets deleted once its been scheduled for deletion. Valid value between 7 and 30 days | number | 30 | no |
| direct_key_info | Information required for a direct key | object({ # List of principals to allow for cryptographic use of key. allow_access_from_principals = list(string) }) | { allow_access_from_principals: [] } | no |
| principal_type | Indicate which type of principal to use in direct_key_info: Must be one of the valid values allowed, Eg. AWS or Service | string | AWS | no |
| service_key_info | Information required for a service key | object({ # List of AWS service names for the kms:ViaService policy condition aws_service_names = list(string) # List of caller account IDs for the kms:CallerAccount policy condition caller_account_ids = list(string) }) | { aws_service_names: [], caller_account_ids: [] } | no |

## Outputs

| **Name** | **Description** |
| --- | --- |
| [key_arn](outputs.tf#L1) | ARN of the KMS key |
| [key_id](outputs.tf#L6) | Key ID of the KMS key |

<!--- END_TF_DOCS --->
