# Terraform Azure DevOps Project

## 🚀 Overview
This project automates Azure infrastructure deployment using **Terraform**. It includes the creation of a **B-Series Virtual Machine**, monitoring alerts, and an **Azure Policy** to restrict resource groups to B-Series VMs only. This project was successfully delivered for a US-based client.  

## 🛠 Features
- ✅ **Azure Resource Group & Virtual Network**
- ✅ **Deploy B-Series VM (Standard_B1ls)**
- ✅ **CPU Credit Alert with Dynamic Threshold (Medium Sensitivity)**
- ✅ **Azure Policy Restricting Resource Group to B-Series VMs**
- ✅ **Email Notifications on Alert Trigger**

## 📌 Prerequisites
- **Terraform** installed ([Download](https://developer.hashicorp.com/terraform/downloads))
- **Azure CLI** installed ([Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli))
- **Azure Subscription** with appropriate permissions

## 🔧 Setup & Deployment
### 1️⃣ **Clone the Repository**
```sh
 git clone https://github.com/yourusername/terraform-azure-devops-project.git
 cd terraform-azure-devops-project
```

### 2️⃣ **Initialize Terraform**
```sh
terraform init
```

### 3️⃣ **Plan Deployment**
```sh
terraform plan
```

### 4️⃣ **Apply Changes**
```sh
terraform apply -auto-approve
```

### 5️⃣ **Verify Deployment**
- Check the **Azure Portal** to confirm resource creation.
- Monitor the **CPU Credit Alert** under Azure Monitor.
- Ensure that non-B-Series VMs cannot be created in the restricted resource group.

## 📬 Contact
If you need **DevOps job support**, feel free to reach out! 🚀  

📩 Email: your.email@example.com  
🔗 LinkedIn: [Your LinkedIn Profile](https://linkedin.com/in/yourprofile)  

## 🏷 Tags
#Terraform #Azure #DevOps #CloudComputing #Automation #AzurePolicy #IAC
