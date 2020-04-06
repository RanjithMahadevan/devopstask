Devops Task Project: 
This Reposiory contains terraform modules and resources code to provision following resources.
1. RHEL Ec2 instance 
2. Security Group and it's rules (ingress ssh traffic to dock ip only and egress traffic  to internet)
3. IMA Ec2 role, instance profile & corresponding policy with specfic s3 bucket acess & KMS encrypt_decrypt permission to encrypt & decrypt datas from S3 bucket 
4. KMS key creation with policy to allow permission only to the EC2 role to manage and access the key for encrypt & decrypt particular s3 bucket data only
5. S3 bucket with kms key server side encryption enabled with bucket policy with Get, put, list, update and delete access to ec2 role only(step3) 

Terraform code module structure:
```
root module/
│   ├── provider.tf        - provider info
│   ├── version.tf         - terraform version(code is build on terraform version 12)
│   ├── variable.tf        - Inputs to modules can be provided here 
|   ├── caller_id.tf       - AWS account data sources (awwountid, user id etc.)
|   ├── compute.tf         - Ec2 RHEL instance with userdata prvision for configuration
|   ├── iam_role.tf        - IAM role, Instance profile and IAM policy creation module
|   ├── kms.tf             - KMS key, Kms alias and policy creation module
|   ├── s3.tf              - S3 bucket, public access control and policy creation module
|   ├── security_group.tf  - security group & corresponding rules creation module
|   ├── template.tf        - template files for AWS json policy & user data templates
|   ├── output.tf          - Resourse output 
├── module/ - (modules folder path)
│   ├──calleridentity/
│   │  ├── variables.tf
│   │  ├── caller_id.tf
|   |  ├── output.tf
|   ├──compute/
|   |  ├── variables.tf
|   |  ├── compute.tf
|   |  ├── output.tf
|   ├──iampolicy/
|   |  ├── variables.tf
|   |  ├── iam_policy.tf
|   |  ├── output.tf
|   ├──iamrole/
|   |  ├── variables.tf
|   |  ├── iam_role.tf
|   |  ├── output.tf
|   ├──instanceprofile/
|   |  ├── variables.tf
|   |  ├── iam_instance_profile.tf
|   |  ├── output.tf
|   ├──kmskey/
|   |  ├── variables.tf
|   |  ├── kms_create.tf
|   |  ├── output.tf
|   ├──kmsalias/
|   |  ├── variables.tf
|   |  ├── kms_alias.tf
|   |  ├── output.tf
|   ├──s3bucket/
|   |  ├── variables.tf
|   |  ├── s3_bucket.tf
|   |  ├── output.tf
|   ├──s3access/
│   │  ├── compute.tf
│   │  ├── variables.tf
│   │  ├── outputs.tf
|   ├──s3policy/
|   |  ├── variables.tf
|   |  ├── s3policy.tf
|   |  ├── output.tf
|   ├──securitygp/
|   |  ├── variables.tf
|   |  ├── security_gp.tf
|   |  ├── output.tf
|   ├──sgrules/cidr_range/ 
|   |  |        ├── variables.tf
|   |  |        ├── security_gp_rules.tf
|   |  |        ├── output.tf
|   ├──sgrules/dest_ip/ - this module is not used but created for future use 
|   |  |        ├── variables.tf
|   |  |        ├── security_gp_rules.tf
|   |  |        ├── output.tf
|   ├──sgrules/dest_selfsg/
|   |  |        ├── variables.tf
|   |  |        ├── security_gp_rules.tf
|   |  |        ├── output.tf
|   ├──sgrules/dest_sg/ - this module is not used but created for future use 
|   |  |        ├── variables.tf
|   |  |        ├── security_gp_rules.tf
|   |  |        ├── output.tf
│   ├──templates/
│   │  ├── templates.tf - policy & userdata rendered
|   ├──templates/policies/
|   |  |        ├── assume_role_ec2_policy.json.tpl - 
|   |  |        ├── ima_ec2_role_policy.json.tpl
|   |  |        ├── kms_policy.json.tpl
|   |  |        ├── s3_policy.json.tpl
│   ├──templates/userscripts/ 
|   |  |        ├── serer_script.sh.tpl - user data script (configuration mgmt on target iinstance)
```

