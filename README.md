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
        module kms_create {

        source      = git@gitlab.com:https://github.com/prakash260/terraform-kms?ref=v1.0;

        key_type    = service

        description = Used to encrypt log aggregation resources

        alias_name  = local.kms_alias_name

        custom_tags = var.custom_tags

        service_key_info = {

            aws_service_names  = [format(ec2.%[s.amazonaws.com
                    ](http: //s.amazonaws.com/), [data.aws_region.current.name](http://data.aws_region.current.name/))]

            caller_account_ids = [data.aws_caller_identity.current.account_id
                    ]
                }
            }
    ```
### example using direct key type
    ```
        module sns_key {

        source = git@gitlab.com:bhp-cloudfactory/aws-components/terraform-aws-kms-key.git?ref=5.0.1

        alias_name           = app-alarm-sns-key

        append_random_suffix = true

        key_type             = direct

        principal_type       = Service

        description          = Used to encrypt sns data

        custom_tags          = var.custom_tags

        direct_key_info = {

            allow_access_from_principals = [[sns.amazonaws.com
                        ](http: //sns.amazonaws.com/), [cloudwatch.amazonaws.com](http://cloudwatch.amazonaws.com/)]
                    }
                }
    ```

**Requirements**

| **Name** | **Version** |
| --- | --- |
| terraform |  1.0.0 |
| aws |  3.7.0 |
| random |  3.0.0 |

**Providers**

| **Name** | **Version** |
| --- | --- |
| aws |  3.7.0 |
| random |  3.0.0 |

**Modules**

No modules.

**Inputs**

| **Name** | **Description** | **Type** | **Default** | **Required** |
| --- | --- | --- | --- | --- |
| [alias_name ](https: //docs.google.com/document#bookmark=id.3dy6vkm)  | Name for the kms key alias. A random string will be appended depending on the &#39;append_random_suffix&#39; variable | string | n/a | yes |
| [description ](https: //docs.google.com/document#bookmark=id.1t3h5sf)  | The description to give to the key | string | n/a | yes |
| [key_type ](https: //docs.google.com/document#bookmark=id.4d34og8)  | Indicate which kind of key to create: &#39;service&#39; for key used by services; &#39;direct&#39; for other keys. Must provide service_key or direct_key maps depending on the type | string | n/a | yes |
| [append_random_suffix ](https: //docs.google.com/document#bookmark=id.2s8eyo1)  | Append a random string to the alias name. Default: true (yes) | bool | true | no |
| [charge_code ](https: //docs.google.com/document#bookmark=id.17dp8vu)  | The code for applying charge code billing logic to the resources | string |  | no |
| [custom_tags ](https: //docs.google.com/document#bookmark=id.3rdcrjn)  | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys | map(any) | {} | no |
| [deletion_window ](https: //docs.google.com/document#bookmark=id.26in1rg)  | Number of days before a key actually gets deleted once it&#39;s been scheduled for deletion. Valid value between 7 and 30 days | number | 30 | no |
| [direct_key_info ](https: //docs.google.com/document#bookmark=id.lnxbz9)  | Information required for a &#39;direct&#39; key | object({ # List of principals to allow for cryptographic use of key. allow_access_from_principals = list(string) }) | { allow_access_from_principals: [] } | no |
| [principal_type ](https: //docs.google.com/document#bookmark=id.35nkun2)  | Indicate which type of principal to use in direct_key_info: Must be one of the valid values allowed, Eg. AWS or Service | string | AWS | no |
| [service_key_info ](https: //docs.google.com/document#bookmark=id.1ksv4uv)  | Information required for a &#39;service&#39; key | object({ # List of AWS service names for the kms:ViaService policy condition aws_service_names = list(string) # List of caller account IDs for the kms:CallerAccount policy condition caller_account_ids = list(string) }) | { aws_service_names: [], caller_account_ids: [] } | no |

**Outputs**

| **Name** | **Description** |
| --- | --- |
| [key_arn ](https: //docs.google.com/document#bookmark=id.44sinio)  | ARN of the KMS key |
| [key_id ](https: //docs.google.com/document#bookmark=id.2jxsxqh)  | Key ID of the KMS key |