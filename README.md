# Multi-Region-VPC-Peering-on-AWS
Demonstration of secure cross-region communication between AWS VPCs  (Mumbai &amp; Singapore) using VPC Peering, Subnets, Route Tables, and EC2.


# Cross-Region VPC Peering on AWS

## 📌 Project Overview
This project demonstrates how to establish **secure communication between two AWS VPCs located in different regions** (Mumbai & Singapore) using VPC Peering.  
It simulates a real-world scenario where applications in different regions need private networking without exposing resources to the internet.

---

## 🛠️ Architecture
- **VPC 1 (Mumbai region)**  
  - Public subnet with Internet Gateway  
  - EC2 instance (used as client)  

- **VPC 2 (Singapore region)**  
  - Private subnet (no internet access)  
  - EC2 instance (used as server)  

- **VPC Peering** established between the two VPCs.  
- Route tables and security groups updated to allow **EC2-to-EC2 private IP communication**.  

![Architecture Diagram](./architecture-diagram.png)

---

## ⚙️ AWS Services Used
- VPC, Subnets, Route Tables  
- Internet Gateway (IGW)  
- VPC Peering  
- EC2 Instances (Amazon Linux)  
- Security Groups  

---

## 🚀 Steps Implemented
1. Created two VPCs (Mumbai & Singapore).  
2. Added subnets (public in Mumbai, private in Singapore).  
3. Configured Internet Gateway for Mumbai VPC.  
4. Launched EC2 instances in both VPCs.  
5. Established **VPC Peering** across regions.  
6. Updated route tables to allow cross-VPC traffic.  
7. Configured security groups for ICMP (ping).  
8. Verified successful **ping communication** between EC2s over private IP.  

---

## ✅ Results
- Achieved **cross-region private communication** between EC2 instances.  
- Singapore private EC2 (no internet access) could communicate with Mumbai EC2 securely via VPC Peering.  

---

## 📷 Screenshots
- VPC creation (Mumbai & Singapore)  
- Route tables configuration  
- Successful EC2 ping test  

---

## 📂 Infrastructure as Code (Optional)
This setup can also be automated using **Terraform**.  
If added, include Terraform scripts in the `/terraform` folder.  

---

## 🔮 Future Improvements
- Test **Transit Gateway** for hub-spoke architecture.  
- Add **monitoring with CloudWatch**.  
- Automate with **Terraform & CI/CD pipeline**.  
