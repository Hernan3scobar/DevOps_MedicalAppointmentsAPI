##### Terraform in AWS

This guide follows the step-by-step instructions presented in the YouTube video: [Learn Terraform (and AWS) by Building a Dev Environment – Full Course for Beginners](https://www.youtube.com/watch?v=iRaai1IBlB0).

This video assumes that you already have your AWS IAM credentials (access key ID and secret access key). We will follow the same strategy and assume that you have these credentials ready. We will also use VS Code as our development environment.



##### Step by Step:

1. **Install the AWS Toolkit Extension and Open It**

2. **Log In Using Your AWS Credentials**  

3. Log in with your IAM account by providing your access key ID and secret access key.

4. **Create the Provider Configuration**  
   
   Open VS Code and create a new file named `provider.tf`, then add the following block:
   
   ```hcl
   terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
   }
   
   provider "aws" {
    shared_credentials_files = ["~/.aws/credentials"]
    profile                  = "9080-2738-5722"
    region                   = "us-west-2"
   }
   ```

5. **Initialize Terraform**  
   
   In a new terminal, type:
   
   ```bash
   terraform init
   ```
   
   This command initializes Terraform with the specified provider configuration.



### VPC

To create a Virtual Private Cloud (VPC), create a new file (for example, `main.tf`) and add the following code:

```hcl
resource "aws_vpc" "my_vpc" {
    cidr_block            = "10.123.0.0/16"
    enable_dns_hostnames  = true  # Enable DNS hostnames (default is true).
    enable_dns_support    = true  # DNS support is enabled by default; added here for clarity.
    tags = {
        Name = "dev"
    }       
}
```

Then, in the terminal, run:

```bash
terraform plan
```

You should see an output similar to:

```hcl
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.my_vpc will be created
  + resource "aws_vpc" "my_vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.123.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "dev"
        }
      + tags_all                             = {
          + "Name" = "dev"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

If everything looks correct, run:

```bash
terraform apply
```

This command creates the VPC in AWS. You can verify the creation in the AWS Management Console or via the AWS Toolkit extension in VS Code.



### Terraform State

Terraform keeps track of resources in its state file. Here are some useful commands:

| Command                | Usage                                                                | Importance                                                                               |
| ---------------------- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `terraform state list` | Lists all the resources recorded in the state file.                  | Provides an overview of the resources managed by Terraform.                              |
| `terraform state show` | Displays detailed attributes for a specific resource from the state. | Helps in debugging and understanding the current configuration of a particular resource. |



##### Subnet

In the `main.tf` file, add the following code to create a public subnet in the VPC:

```hcl
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = "10.123.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"
    tags = {
        Name = "public"
    }  
}
```

Then, run:

```bash
terraform apply -auto-approve
```

This will deploy the subnet into your VPC. You can verify it in the AWS console.



##### Internet Gateway

To enable internet connectivity, add the following code in the `main.tf` file to create an Internet Gateway:

```hcl
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igw"
  }
}
```



##### Route Table

Configure the routing by adding the following blocks:

```hcl
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}
```

This sets a default route for outbound traffic and associates it with the public subnet.



##### Security Group

Next, create a security group to allow all inbound and outbound traffic:

```hcl
resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```



###### Server AMI

Create a new file named `datasources.tf` (or add to an existing file) to define a data source for an AWS AMI:

```hcl
data "aws_ami" "server_ami" {
    most_recent = true
    owners      = ["099720109477"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }    
}
```



##### SSH Key

To enable SSH access, first generate an SSH key by running:

```bash
ssh-keygen -t ed25519
```

When prompted, provide a path and file name. You can save the file as `~/.ssh/my_ssh_key`. Then, add the following block in the `main.tf` file:

```hcl
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = file("~/.ssh/my_ssh_key.pub")
}
```



##### EC2 Instance

Finally, to deploy an EC2 instance, add the following code:

```hcl
resource "aws_instance" "my_instance" {
  ami                    = data.aws_ami.server_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key_pair.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "my_instance"
  }

  root_block_device {
    volume_size = 10
  }
}
```



##### User Data and SSH Access

To configure user data (for initialization) and access your instance, first retrieve the public IP address by running:

```bash
terraform state show aws_instance.my_instance
```

Identify the `public_ip` address, then use SSH to connect:

```bash
ssh -i ~/.ssh/my_ssh_key ubuntu@your_public_ip
```

When prompted, type **yes** to confirm the connection. This establishes your development environment on the EC2 instance.



### Additional Sections Covered in the Video

The video also discusses several important topics that you can explore further:

- **AWS IAM Setup:** Detailed instructions on setting up an AWS IAM account and managing credentials.

- **Local Environment Setup:** Guidelines on configuring your local development environment (using VS Code) for Terraform.

- **Terraform Destroy:** How to safely remove resources using `terraform destroy`.

- **Provisioners and Template Files:** Using provisioners to run scripts on the EC2 instance during initialization.

- **Variables and Outputs:** Best practices for parameterizing your Terraform configurations and outputting useful information after deployment.

- **Conditional Expressions:** How to manage conditional logic within your configuration files.
