# Multi-Region-VPC-Peering-on-AWS
Demonstration of secure cross-region communication between AWS VPCs  (Mumbai &amp; Singapore) using VPC Peering, Subnets, Route Tables, and EC2.


# Cross-Region VPC Peering on AWS

##  Project Overview
This project demonstrates how to establish **secure communication between two AWS VPCs located in different regions** (Mumbai & Singapore) using VPC Peering. It simulates a real-world scenario where applications in different regions need private networking without exposing resources to the internet.

---

##  Architecture
- **VPC 1 (Mumbai region)**  
  - Public subnet with Internet Gateway  
  - EC2 instance (used as client)  
<img width="1111" height="499" alt="image" src="https://github.com/user-attachments/assets/213ffe5f-524c-403c-96e3-0f4a298fd2aa" />


- **VPC 2 (Singapore region)**  
  - Private subnet (no internet access)  
  - EC2 instance (used as server)
  - <img width="1116" height="482" alt="image" src="https://github.com/user-attachments/assets/946e525c-1232-4fe7-beac-25e87afbfdeb" />


- **VPC Peering** established between the two VPCs.  
- Route tables and security groups updated to allow **EC2-to-EC2 private IP communication**.  
<img width="1116" height="498" alt="image" src="https://github.com/user-attachments/assets/59f6be23-a41e-4d58-9691-5523e194ecb3" />

---

##  AWS Services Used
- VPC, Subnets, Route Tables  
- Internet Gateway (IGW)  
- VPC Peering  
- EC2 Instances (Amazon Linux)  
- Security Groups  

---

##  Steps Implemented
1. Created two VPCs (Mumbai & Singapore).  
2. Added subnets (public in Mumbai, private in Singapore).  
3. Configured Internet Gateway for Mumbai VPC.  
4. Launched EC2 instances in both VPCs.  
5. Established **VPC Peering** across regions.  
6. Updated route tables to allow cross-VPC traffic.  
7. Configured security groups for ICMP (ping).  
8. Verified successful **ping communication** between EC2s over private IP.  

---

##  Results
- Achieved **cross-region private communication** between EC2 instances.  
- Singapore private EC2 (no internet access) could communicate with Mumbai EC2 securely via VPC Peering.  

---

##  Screenshots
- VPC creation (Mumbai & Singapore)  
- Route tables configuration  
- Successful EC2 ping test  
<img width="1098" height="324" alt="image" src="https://github.com/user-attachments/assets/21c72f4c-0e20-4b83-9f46-d6732ed55331" />
<img width="770" height="402" alt="image" src="https://github.com/user-attachments/assets/858df665-cff0-4b69-a4b3-e9d8f35faf90" />

---

## 📂 Infrastructure as Code (Optional)
This setup can also be automated using **Terraform**.  
If added, include Terraform scripts in the `/terraform` folder.  

---
