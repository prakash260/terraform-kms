# **AWS KMS Key**

AWS Key Management Service (KMS) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications. This component creates a KMS key that is used to encrypt data across the platform.

It creates:

- _KMS key_: Resource which creates KMS key
- _KMS key policy_: Key policies which permits cross account access, access through AWS principles and AWS services based on some conditions and input variables

**Architecture**

N/A

**Owner and POC**

The owner and POC of this module

**Run-Book**

This runbook provides series of steps to use terraform components in a blueprint which will automatically builds/deploy a kMS key and Policy in an AWS account.

**Pre-requisites**

**IMPORTANT NOTE**

1. Required version of Terraform is mentioned in [meta.tf
](http: //meta.tf/).
2. Go through [inputs.tf
](http: //inputs.tf/) for understanding each terraform variable before running this component.

**AWS Accounts**

Needs the following accounts:

1. Compute/Spoke Account (AWS account where KMS Key is to be created)

**Getting Started**

**How to use this component in a blueprint**

IMPORTANT: We periodically release versions for the components. Since, master branch may have on-going changes, best practice would be to use a released version in form of a tag (e.g. ?ref=x.y.z)

### example using service key type

module &quot;logs\_kms&quot; {

  source      = &quot;git@gitlab.com:bhp-cloudfactory/aws-components/terraform-aws-kms-key.git?ref=5.0.1&quot;

  key\_type    = &quot;service&quot;

  description = &quot;Used to encrypt log aggregation resources&quot;

  alias\_name  = local.kms\_alias\_name

  custom\_tags = var.custom\_tags

  service\_key\_info = {

    &quot;aws\_service\_names&quot;  = [format(&quot;ec2.%[s.amazonaws.com
            ](http: //s.amazonaws.com/)&quot;, [data.aws\_region.current.name](http://data.aws_region.current.name/))]

    &quot;caller\_account\_ids&quot; = [data.aws\_caller\_identity.current.account\_id
            ]
        }
    }

### example using direct key type

module &quot;sns\_key&quot; {

  source = &quot;git@gitlab.com:bhp-cloudfactory/aws-components/terraform-aws-kms-key.git?ref=5.0.1&quot;

  alias\_name           = &quot;app-alarm-sns-key&quot;

  append\_random\_suffix = true

  key\_type             = &quot;direct&quot;

  principal\_type       = &quot;Service&quot;

  description          = &quot;Used to encrypt sns data&quot;

  custom\_tags          = var.custom\_tags

  direct\_key\_info = {

    &quot;allow\_access\_from\_principals&quot; = [&quot;[sns.amazonaws.com
                ](http: //sns.amazonaws.com/)&quot;, &quot;[cloudwatch.amazonaws.com](http://cloudwatch.amazonaws.com/)&quot;]
            }
        }

**Requirements**

| **Name** | **Version** |
| --- | --- |
| [terraform
        ](https: //docs.google.com/document#bookmark=id.gjdgxs)  | \&gt;= 1.0.0 |
| [aws
        ](https: //docs.google.com/document#bookmark=id.30j0zll)  | \&gt;= 3.7.0 |
| [random
        ](https: //docs.google.com/document#bookmark=id.1fob9te)  | \&gt;= 3.0.0 |

**Providers**

| **Name** | **Version** |
| --- | --- |
| [aws
        ](https: //docs.google.com/document#bookmark=id.3znysh7)  | \&gt;= 3.7.0 |
| [random
        ](https: //docs.google.com/document#bookmark=id.2et92p0)  | \&gt;= 3.0.0 |

**Modules**

No modules.

**Inputs**

| **Name** | **Description** | **Type** | **Default** | **Required** |
| --- | --- | --- | --- | --- |
| [alias\_name
        ](https: //docs.google.com/document#bookmark=id.3dy6vkm)  | Name for the kms key alias. A random string will be appended depending on the &#39;append\_random\_suffix&#39; variable | string | n/a | yes |
| [description
        ](https: //docs.google.com/document#bookmark=id.1t3h5sf)  | The description to give to the key | string | n/a | yes |
| [key\_type
        ](https: //docs.google.com/document#bookmark=id.4d34og8)  | Indicate which kind of key to create: &#39;service&#39; for key used by services; &#39;direct&#39; for other keys. Must provide service\_key or direct\_key maps depending on the type | string | n/a | yes |
| [append\_random\_suffix
        ](https: //docs.google.com/document#bookmark=id.2s8eyo1)  | Append a random string to the alias name. Default: true (yes) | bool | true | no |
| [charge\_code
        ](https: //docs.google.com/document#bookmark=id.17dp8vu)  | The code for applying charge code billing logic to the resources | string | &quot;&quot; | no |
| [custom\_tags
        ](https: //docs.google.com/document#bookmark=id.3rdcrjn)  | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys | map(any) | {} | no |
| [deletion\_window
        ](https: //docs.google.com/document#bookmark=id.26in1rg)  | Number of days before a key actually gets deleted once it&#39;s been scheduled for deletion. Valid value between 7 and 30 days | number | 30 | no |
| [direct\_key\_info
        ](https: //docs.google.com/document#bookmark=id.lnxbz9)  | Information required for a &#39;direct&#39; key | object({
     # List of principals to allow for cryptographic use of key.
     allow\_access\_from\_principals = list(string)
    }) | {
   &quot;allow\_access\_from\_principals&quot;: []
    } | no |
| [principal\_type
    ](https: //docs.google.com/document#bookmark=id.35nkun2)  | Indicate which type of principal to use in direct\_key\_info: Must be one of the valid values allowed, Eg. AWS or Service | string | &quot;AWS&quot; | no |
| [service\_key\_info
    ](https: //docs.google.com/document#bookmark=id.1ksv4uv)  | Information required for a &#39;service&#39; key | object({
     # List of AWS service names for the kms:ViaService policy condition
     aws\_service\_names = list(string)
     # List of caller account IDs for the kms:CallerAccount policy condition
     caller\_account\_ids = list(string)
}) | {
   &quot;aws\_service\_names&quot;: [],
   &quot;caller\_account\_ids&quot;: []
} | no |

**Outputs**

| **Name** | **Description** |
| --- | --- |
| [key\_arn
](https: //docs.google.com/document#bookmark=id.44sinio)  | ARN of the KMS key |
| [key\_id
](https: //docs.google.com/document#bookmark=id.2jxsxqh)  | Key ID of the KMS key |