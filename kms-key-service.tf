
resource "aws_kms_key" "service_key" {
  description             = var.description
  enable_key_rotation     = true
  deletion_window_in_days = var.deletion_window

  policy = data.aws_iam_policy_document.kms_key_policy_via_service[0].json

  tags = merge({
    Name       = local.alias_name
    Alias      = var.alias_name
    ChargeCode = var.charge_code
  }, var.custom_tags)

  count = local.service_key_count
}

resource "aws_kms_alias" "service_key" {
  name          = "alias/${local.alias_name}"
  target_key_id = aws_kms_key.service_key[0].key_id
  count         = local.service_key_count
}

data "aws_iam_policy_document" "kms_key_policy_via_service" {
  statement {
    sid       = "Allow Admin"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid = "Allow Cryptography"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey",
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = var.service_key_info.aws_service_names
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = var.service_key_info.caller_account_ids
    }
  }

  count = local.service_key_count
}
