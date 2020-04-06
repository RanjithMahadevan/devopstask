## Devops Task Project: ##
This Reposiory contains terraform modules and resources code to provision following resources.
1. RHEL Ec2 instance 
2. Security Group and it's rules (ingress ssh traffic to dock ip only and egress traffic  to internet)
3. IMA Ec2 role, instance profile & corresponding policy with specfic s3 bucket acess & KMS encrypt_decrypt permission to encrypt & decrypt datas from S3 bucket 
4. KMS key creation with policy to allow permission only to the EC2 role to manage and access the key for encrypt & decrypt particular s3 bucket data only
5. S3 bucket with kms key server side encryption enabled with bucket policy with Get, put, list, update and delete access to ec2 role only(step3)
6. Configuration changes will be managed using shell script userdata, which will install docker, s3fs packages and mount s3 bucket to ec2 instance on /opt/s3 dir.

 Note:Data between s3 bucket to Ec2 instace is encrypted at transit & rest with KMS key CMK which ensure that the storage is securely mounted with Ec2 instance, Also s3 bucket policy is restricted only to the ec2 instance provisioned by the module and the Ec2 instance permission has been defined by IAM policy which has been attached to ec2 role with s3 permission(put, get) and kms key permission to encrypt & decrypt. 
 
 ## Architecture diagram: ##
 
![Image of Architecture](https://github.com/RanjithMahadevan/devopstask/blob/develop/architecture%20diagram.PNG)

## Terraform code module structure: ##
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
├── modules/ - (modules folder path)
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

## prerequisite:  ##
 * code is developed using terraform version 12, ensure that you're using right version.  
 * Refer the below link to install terraform 12 on your machine.  
 * installation procedure:https://learn.hashicorp.com/terraform/getting-started/install.html   
 * Variables should be popullated in variables.tf file in the root path,please refer example/README.md for  variables information.  

 ## Module execution steps: ## 
 * Ensure that you have installed terraform version 12 on your machine  
 * switch your cli or git bash to code root path and ececute the following command  
 * terraform -v     (to ensure version)  
 * terraform init   (to initialize modules & necessary terraform plugins)  
 * terraform plan   (to verify the list of resource that will be provision and ensure no errors in code)   
 * terraform apply -auto-approve (to create a resourse defined in code)    
 * terraform destroy -target=module.instance.aws_instance.dock -auto-approve (To terminate Ec2 instance alone, so that other resources like s3 bucket, kms, IAM role etc.. will be exist.) 
 * terraform apply -auto-approve  (terraform apply cmd should be executed when ever the instance is terminated and reprovisioned again)

 * terraform -v    - (to ensure version)  
 * terraform init  - (to initialize modules & necessary terraform plugins)  
 * terraform plan  - (to verify the list of resource that will be provision and ensure no errors in code)   
 * terraform apply -auto-approve - to create a resourse defined in code  
 * terraform destroy -target=module.instance.aws_instance.dock -auto-approve - To terminate Ec2 instance alone, so that other resources like s3 bucket, kms, IAM role etc.. will be exist.   

        note: "module.instance.aws_instance.doc" is specfic to ec2 instance resource defined in the module.
            To provision the Ec2 instance again, execute "terraform apply -auto-approve"         


## Description about the Module: ##
        This module has created to provision single RHEL or centos Ec2 instance mounted with external storage S3 bucket with secure manner on your own VPC and subnet.Also this code can be reusable on any environment to provision mentioned aws resources.

       Security features:  
                    * Ec2 SSH ingress acess is allowed only to the specfic IP which yoy can mention the variable 
                    * Ec2 instance permission is restricted only to the s3 bucket created in the module
                    * S3 bucket is encrypted by KMS CMK key and decrypt permission only allowed to the EC2 instance 
                    * KMS key permission is restricted to rrot account & EC2 role attached to the instance.  
                    * Data between s3 bucket to Ec2 instance is encrypted at rest and transit.  

## Reference Links: ## 
       terraform:  
                    1. https://www.terraform.io/docs/providers/aws/r/s3_bucket.html  
                    2. https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html  
                    3. https://www.terraform.io/docs/providers/aws/r/s3_account_public_access_block.html  
                    4. https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html  
                    5. https://www.terraform.io/docs/providers/aws/r/iam_role.html  
                    6. https://www.terraform.io/docs/providers/aws/r/instance.html  
                    7. https://www.terraform.io/docs/providers/aws/r/kms_key.html  
                    8. https://www.terraform.io/docs/providers/aws/r/kms_grant.htm  
       S3FS:  
                    9. https://github.com/dask/s3fs  
                    
       
 *Please write me @ creativeranjith@gmail.com for any additional information. 
       
        
