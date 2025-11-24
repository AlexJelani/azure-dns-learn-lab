# Lab 09a - Implement Web Apps

## Overview
This lab demonstrates Azure Web Apps implementation with deployment slots, autoscaling, and continuous deployment from GitHub.

## What You'll Learn
- Create and configure Azure Web Apps
- Set up deployment slots for staging/production
- Configure continuous deployment from GitHub
- Implement autoscaling based on CPU metrics
- Perform slot swaps between staging and production

## Architecture
- **Resource Group**: `az104-rg9`
- **App Service Plan**: Premium V3 P1V3 (Linux)
- **Web App**: PHP 8.2 runtime
- **Deployment Slots**: Production + Staging
- **Source Control**: GitHub integration
- **Autoscaling**: CPU-based (1-2 instances)

## Prerequisites
- Azure CLI installed and logged in
- Terraform installed
- Azure subscription with appropriate permissions

## Deployment Steps

1. **Initialize Terraform**
   ```bash
   cd labs/09a-web-apps
   terraform init
   ```

2. **Review the plan**
   ```bash
   terraform plan
   ```

3. **Deploy infrastructure**
   ```bash
   terraform apply
   ```

4. **Note the outputs** - URLs for production and staging slots

## Lab Tasks

### Task 1: Verify Web App Creation
- Check the production web app URL from terraform output
- Verify PHP 8.2 runtime is configured

### Task 2: Test Staging Slot
- Access the staging slot URL
- Verify "Hello World" application is deployed from GitHub

### Task 3: Perform Slot Swap
Use Azure CLI to swap slots:
```bash
az webapp deployment slot swap \
  --resource-group az104-rg9 \
  --name <web-app-name> \
  --slot staging \
  --target-slot production
```

### Task 4: Test Autoscaling
Generate load to trigger autoscaling:
```bash
# Use Azure Load Testing or external tools
# Monitor scaling in Azure portal
```

### Task 5: Monitor and Verify
- Check Azure portal for deployment history
- Verify autoscaling rules are active
- Monitor application performance

## Key Features Implemented

### Deployment Slots
- **Staging slot** with GitHub integration
- **Production slot** for live traffic
- Easy slot swapping capability

### Autoscaling Configuration
- **Scale out**: CPU > 70% → Add 1 instance
- **Scale in**: CPU < 25% → Remove 1 instance  
- **Limits**: 1-2 instances maximum

### Continuous Deployment
- **Source**: GitHub repository
- **Repository**: `Azure-Samples/php-docs-hello-world`
- **Branch**: `master`

## Cost Estimation
- **App Service Plan P1v3**: ~$73/month
- **Autoscaling**: Additional costs when scaled out
- **Lab duration**: ~$0.05 for 20-minute exercise

## Cleanup
```bash
terraform destroy
```

## Troubleshooting
- If deployment fails, try different region
- Ensure unique web app names globally
- Check Azure quotas for Premium plans

## Learning Resources
- [Azure App Service Documentation](https://docs.microsoft.com/en-us/azure/app-service/)
- [Deployment Slots](https://docs.microsoft.com/en-us/azure/app-service/deploy-staging-slots)
- [Autoscaling](https://docs.microsoft.com/en-us/azure/app-service/manage-scale-up)