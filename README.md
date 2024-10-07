# **Node.js Threat Model App Deployment on AWS**

### **Overview**

This project walks through the deployment of a **Node.js threat model app** using modern cloud infrastructure tools like **Docker**, **Amazon ECS (Fargate)**, and **Terraform**. The app is hosted on **AWS** and accessed via a custom subdomain: `tm.qaisnavaei.com`, managed through **Amazon Route 53**.

The goal is to create a **scalable**, **reliable**, and **automated** deployment pipeline for a containerised application.

---

### **Key Components**

- **Docker**: Packages the application into a container.
- **Elastic Container Registry (ECR)**: Stores the Docker image securely.
- **ECS (Fargate)**: Runs the container serverlessly, so no need to manage underlying infrastructure.
- **Application Load Balancer (ALB)**: Distributes traffic efficiently to ECS tasks.
- **Route 53**: Handles DNS, making the app accessible via a custom subdomain.

---

### **High-Level Architecture**

1. **VPC**: Provides an isolated, secure network.
2. **Subnets**: Ensures high availability by spreading the infrastructure across multiple availability zones.
3. **ECS Cluster**: Runs and manages containerised tasks with Fargate.
4. **Application Load Balancer**: Handles incoming traffic and routes it to the ECS service.
5. **Route 53 DNS**: Maps the custom subdomain (`tm.qaisnavaei.com`) to the ALB for public access.

---

### **The Dockerfile**

Here’s a quick look at the Dockerfile used to containerise the Node.js app:

```dockerfile
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
COPY yarn.lock ./
RUN yarn install
COPY . .
EXPOSE 3000
CMD [ "yarn", "start" ]
```

**Why this setup?**
- **Lightweight**: Uses `node:18-alpine`, a slimmed-down Node.js image for efficiency.
- **Consistency**: Defines `/app` as the working directory and copies over dependencies.
- **Port Exposure**: Exposes port 3000, where the app listens.
- **Default Command**: Starts the app using `yarn start`.

---

### **Terraform for Infrastructure as Code**

Terraform provisions and configures all the necessary cloud resources for deployment. Let's break it down into key parts.

#### **1. Networking: VPC, Subnets, and Security**

Terraform creates a **Virtual Private Cloud (VPC)** with isolated subnets across availability zones and defines **security groups** to allow controlled access.

```hcl
resource "aws_vpc" "app-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "tm-subnet" {
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
}

resource "aws_security_group" "tm-sg" {
  vpc_id = aws_vpc.app-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

- **VPC**: Isolates your app in a private network.
- **Subnets**: Distributes resources across availability zones for reliability.
- **Security Groups**: Opens up HTTP (port 80) and HTTPS (port 443) for incoming traffic.

#### **2. Compute: ECS Fargate**

ECS runs the app inside containers without you managing the underlying servers (thanks to Fargate).

```hcl
resource "aws_ecs_task_definition" "my-tm-task" {
  family = "my-tm-task"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([{
    name = "tm-container"
    image = "009160072276.dkr.ecr.eu-west-2.amazonaws.com/qais/threat-project:latest"
    portMappings = [{ containerPort = 3000 }]
  }])
}

resource "aws_ecs_service" "my-tm-service" {
  cluster         = aws_ecs_cluster.my-app-cluster.id
  task_definition = aws_ecs_task_definition.my-tm-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
}
```

- **Task Definition**: Defines the container image and resources (CPU, memory).
- **Service**: Ensures the task is always running.

#### **3. Load Balancer: ALB**

An **Application Load Balancer (ALB)** handles traffic distribution to ensure fault tolerance and scalability.

```hcl
resource "aws_lb" "app-lb" {
  name = "app-lb"
  load_balancer_type = "application"
  subnets = [aws_subnet.tm-subnet.id, aws_subnet.tm-subnet2.id]
}

resource "aws_lb_target_group" "tm-tg" {
  port = 3000
  protocol = "HTTP"
  vpc_id = aws_vpc.app-vpc.id
}

resource "aws_lb_listener" "tm_https" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = "arn:aws:acm:eu-west-2:..."
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tm-tg.arn
  }
}
```

- **ALB**: Distributes traffic across ECS tasks.
- **Target Group**: Ensures traffic reaches the right app port (3000).
- **SSL Listener**: Secures traffic with HTTPS.

#### **4. DNS: Route 53**

Finally, Route 53 configures the DNS to map the custom subdomain to the load balancer.

```hcl
resource "aws_route53_record" "tm_record" {
  zone_id = data.aws_route53_zone.lab_zone.id
  name    = "tm.qaisnavaei.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.app-lb.dns_name]
}
```

---

### **Deployment Process**

1. **Dockerise the App**: Build a container for your Node.js app using Docker.
2. **Push to ECR**: Store the Docker image in AWS Elastic Container Registry (ECR).
3. **Terraform Setup**: Use Terraform to deploy your app on ECS (Fargate) and expose it via the ALB.
4. **Configure DNS**: Set up Route 53 to route traffic to your ALB using a custom subdomain.

---

### **Challenges and Learnings**

- **Terraform Mastery**: Understanding the structure of Terraform took some trial and error. Using variables and modularising the infrastructure made the configuration much more flexible.
- **DNS Setup**: Configuring the **NS record** for Route 53 to link the subdomain (`tm.qaisnavaei.com`) was crucial and took time to troubleshoot.

---

### **Future Enhancements**

- **CI/CD Pipeline**: Automate the deployment process with a CI/CD pipeline (e.g., GitHub Actions) to build and deploy the Docker image automatically.
- **Infrastructure Variables**: Use variables for better flexibility in Terraform, especially for CIDR blocks, region, and environment-based settings.

---

### **Conclusion**

This project successfully demonstrates how to deploy a Node.js app on AWS using Docker and Terraform. It’s scalable, reliable, and accessible via a custom subdomain. The use of Fargate abstracts infrastructure management, and Terraform automates the entire setup.

Next steps include automating the deployment process and further optimising the infrastructure for scalability across environments.