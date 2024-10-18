# **Threat Modelling Tool - AWS Deployment**

### **Overview**

This project demonstrates how to deploy a **Node.js-based Threat Modelling Tool** using modern infrastructure tools like **Docker**, **Amazon ECS (Fargate)**, and **Terraform**. The app is securely hosted on **AWS** with a custom subdomain (`tm.qaisnavaei.com`) managed through **Amazon Route 53**.

Our goal is to create a **scalable**, **secure**, and **automated** infrastructure for the tool, ensuring HTTPS access and high availability.

---

### **Key Features**

- **Dockerised Application**: The app is packaged as a Docker container.
- **AWS Fargate**: Provides a serverless platform to run the containers without managing infrastructure.
- **HTTPS Security**: Enforced using **AWS Certificate Manager (ACM)** for secure, encrypted communication.
- **Custom Domain**: Access the tool at `tm.qaisnavaei.com` via Route 53 DNS.
- **Load Balancer**: Utilises an **Application Load Balancer (ALB)** for traffic distribution and fault tolerance.

---

### **Why This Setup Matters?**

1. **Security with HTTPS**: Ensures encrypted communication and protects user data in transit.
2. **Scalability with AWS Fargate**: Automatically scales resources based on traffic without managing servers.
3. **Custom Domain**: Simplifies access and branding with a memorable subdomain (`tm.qaisnavaei.com`).
4. **Automation with Terraform**: Infrastructure as Code (IaC) ensures consistency and version control.

---

### **Infrastructure Components**

1. **VPC (Virtual Private Cloud)**: Provides a secure, isolated network for the app.
2. **ECS (Fargate)**: Runs the containerised app serverlessly.
3. **ALB (Application Load Balancer)**: Ensures efficient traffic distribution and fault tolerance.
4. **Route 53 DNS**: Maps the custom domain to the ALB.
5. **ACM (AWS Certificate Manager)**: Manages SSL certificates to enforce HTTPS.

---

### **Screenshot**

Here is a screenshot of the **Threat Modelling Tool**:

![App Screenshot](https://github.com/qais20/Threat-composer-app/blob/72f1f95d15f0e5c259a85a5ab655f2be6713ecd8/Screenshot%202024-10-18%20223933.jpg)

---

### **Setup Instructions**

#### **1. Clone the Repository**
```bash
git clone [repo-url]
cd [repo-directory]
```

#### **2. Docker Setup**
Build and run the application locally using Docker:
```bash
yarn install
yarn build
yarn start
```
Access the app locally at `http://localhost:3000`.

#### **3. Deploy with Terraform**

Initialise Terraform:
```bash
terraform init
```

Preview changes:
```bash
terraform plan
```

Apply the infrastructure deployment:
```bash
terraform apply
```

Once deployed, access the tool via the custom domain.

#### **4. Clean Up Resources**
After the demo, clean up the AWS resources:
```bash
terraform destroy
```

---

### **Future Enhancements**

- **CI/CD Pipeline**: Automate deployment to AWS using a CI/CD tool like GitHub Actions.
- **Modularised Infrastructure**: Break the Terraform code into smaller modules for better management.
- **Auto-Scaling**: Implement auto-scaling policies to adjust resources during high demand.

---

### **Conclusion**

This project demonstrates a secure and scalable infrastructure for the **Threat Modelling Tool** using AWS services and Docker containers. It’s designed for ease of deployment, reliability, and security, with HTTPS enforcement and custom DNS.

---