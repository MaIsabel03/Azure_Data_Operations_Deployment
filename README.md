# **Azure Data Operations — Terraform Infrastructure Deployment**

## **Project Overview**

This team project demonstrates the deployment and management of cloud infrastructure using **Terraform and Microsoft Azure**.

The environment includes an Azure resource group, virtual network, subnet, network interface, public IP, network security group, Linux virtual machine, Python web server, and project data file.

The project demonstrates an end-to-end Infrastructure as Code (IaC) workflow, including infrastructure planning, automated provisioning, application configuration, validation, and infrastructure teardown.

## **My Role**

**Team Lead & Deployment Lead**

I coordinated the team's Terraform contributions, integrated the submitted components into the final configuration, deployed the complete Azure environment, validated the web server and file delivery, and completed the infrastructure teardown using Terraform.

## **Technical Contributions**

My contributions included:

- Integrating Terraform configurations submitted by team members
- Configuring the Azure Linux virtual machine
- Configuring the Azure public IP and network interface
- Creating and configuring the Network Security Group
- Configuring inbound SSH and web-server access
- Configuring the Python web server on port 8080
- Integrating the project data file into the deployment
- Executing and validating the complete Terraform deployment
- Verifying the deployed environment through a web browser
- Using `terraform destroy` to completely remove the deployed resources

## **Infrastructure**

The Terraform configuration provisions and manages:

- Azure Resource Group
- Virtual Network
- Subnet
- Network Interface
- Static Public IP
- Network Security Group
- Linux Virtual Machine
- Python HTTP Server
- Project data file

## **Deployment Workflow**

The project followed a complete Infrastructure as Code workflow:

```text
Terraform Configuration
        ↓
terraform plan
        ↓
terraform apply
        ↓
Azure Infrastructure Provisioned
        ↓
Python Web Server Configured
        ↓
Project File Uploaded
        ↓
Browser Validation
        ↓
terraform destroy
        ↓
Azure Infrastructure Removed
```

## **Web Server Validation**

A Python web server was configured on port `8080` on the Linux virtual machine.

The project data file was uploaded to the VM and accessed through a web browser using the VM's public IP address.

The file was changed from CSV to TXT for browser validation because modern browsers may download CSV files rather than display their contents directly.

This allowed the deployment to be visually validated while keeping the underlying infrastructure and Terraform workflow unchanged.

## **Infrastructure Teardown**

After validating the deployment, `terraform destroy` was used to remove the deployed infrastructure.

The teardown removed the VM, network interface, public IP, network security group, subnet, virtual network, and resource group.

This demonstrated the ability to manage the complete infrastructure lifecycle through Terraform.

## **Project Documentation**

Detailed deployment evidence is available in:

`Documentation/Azure_Data_Operations_Terraform_Deployment.pdf`

The documentation includes evidence of:

- Initial Azure environment
- Terraform plan
- Terraform apply
- Azure resources after deployment
- Web server and file validation
- Terraform destroy
- Confirmation that Azure resources were removed

## **Project Structure**

```text
Azure_Data_Operations_Deployment/
│
├── README.md
├── main.tf
├── group6.txt
│
├── terraform/
│   ├── vm.tf
│   ├── network.tf
│   └── outputs.tf
│
└── Documentation/
    └── Azure_Data_Operations_Terraform_Deployment.pdf
```

## **Programs & Tools Used**

- **Terraform** — Infrastructure as Code and automated cloud provisioning
- **Microsoft Azure** — Cloud infrastructure and virtual machine deployment
- **Linux / Ubuntu** — Virtual machine operating system
- **Python 3** — Web server configuration
- **GitHub** — Version control and project collaboration
- **SSH** — Remote VM access and configuration

## **Skills Demonstrated**

- Infrastructure as Code
- Cloud infrastructure deployment
- Terraform configuration
- Azure resource management
- Network configuration
- Network security configuration
- Linux virtual machine deployment
- Web server configuration
- Infrastructure lifecycle management
- Technical troubleshooting
- Team leadership
- Project coordination
- Code integration
- Deployment validation
- Version control

## **Project Context**

This project was completed as part of a team-based Data Operations project and demonstrates the use of Infrastructure as Code to automate cloud infrastructure deployment.

The project demonstrates both technical and leadership experience through the integration of multiple team contributions, end-to-end Azure deployment, validation, and infrastructure teardown.

It demonstrates skills applicable to technical Data Analyst, Business Analyst, Data Operations, and cloud-oriented roles.
