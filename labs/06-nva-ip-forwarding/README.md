# Lab 06 - Network Virtual Appliance (NVA) with IP Forwarding

This lab demonstrates how to deploy a Network Virtual Appliance (NVA) in Azure and configure it to forward IP traffic. This is a foundational step for scenarios where an NVA is used to secure and monitor traffic between different network segments.

## What it creates

-   **Resource Group**: `az104-rg-nva-lab`
-   **Virtual Network**: `vnet` (10.0.0.0/16)
    -   **Subnets**:
        -   `publicsubnet` (10.0.0.0/24)
        -   `privatesubnet` (10.0.1.0/24)
        -   `dmzsubnet` (10.0.2.0/24)
-   **Network Virtual Appliance (NVA)**: An Ubuntu 22.04 LTS VM named `nva` deployed into the `dmzsubnet`. This VM has no public IP address.
-   **IP Forwarding**: Enabled on the NVA's Azure Network Interface and within the NVA operating system.

## Architecture


The NVA in the DMZ subnet will be configured to forward traffic, acting as a router or firewall for traffic between the public and private subnets (though routing rules are not configured in this specific lab, only the NVA's IP forwarding capability).

## Deployment

1.  **Prerequisites**:
    *   An Azure subscription.
    *   Azure CLI installed and logged in (`az login`).
    *   Bicep CLI installed (usually comes with Azure CLI, or `az bicep install`).

2.  **Navigate to the lab directory**:
    ```bash
    cd /workspaces/azure-dns-learn-lab/labs/06-nva-ip-forwarding
    ```

3.  **Make scripts executable**:
    ```bash
    chmod +x deploy.sh cleanup.sh
    ```

4.  **Deploy the infrastructure**:
    Run the `deploy.sh` script, providing a strong password for the NVA VM.
    ```bash
    ./deploy.sh "<YourComplexPassword>"
    ```
    Replace `<YourComplexPassword>` with a password that meets Azure's complexity requirements (e.g., at least 12 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character).

    The script will create all necessary resources and configure the NVA.

5.  **Verify Deployment**:
    After deployment, you can verify the resources in the Azure portal. To connect to the NVA, you would typically use Azure Bastion or a jumpbox VM in the public subnet, as the NVA has no public IP.

## Cleanup

To remove all resources created by this lab:

1.  **Navigate to the lab directory**:
    ```bash
    cd /workspaces/azure-dns-learn-lab/labs/06-nva-ip-forwarding
    ```

2.  **Run the cleanup script**:
    ```bash
    ./cleanup.sh
    ```
    This will initiate the deletion of the resource group `az104-rg-nva-lab`.
