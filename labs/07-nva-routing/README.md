# Lab 07 - NVA Traffic Routing

This lab demonstrates routing traffic through a Network Virtual Appliance (NVA) and testing the routing behavior.

## What it creates

- **VNet**: `vnet` (10.0.0.0/16)
- **Subnets**:
  - `publicsubnet` (10.0.0.0/24) - with route table
  - `privatesubnet` (10.0.1.0/24) - target subnet  
  - `dmzsubnet` (10.0.2.0/24) - contains NVA
- **VMs**:
  - `nva` - Network Virtual Appliance (10.0.2.4)
  - `public` - Test VM in public subnet
  - `private` - Test VM in private subnet
- **Route Table**: Routes traffic from public to private subnet via NVA

## Traffic Flow

```
Public VM (10.0.0.x) → Route Table → NVA (10.0.2.4) → Private VM (10.0.1.x)
Private VM (10.0.1.x) → Direct → Public VM (10.0.0.x)
```

## Deployment

```bash
chmod +x *.sh
./deploy.sh 'YourPassword123!'
```

## Testing

```bash
./test-routing.sh
```

Expected results:
- **Public to Private**: Traffic routes through NVA (10.0.2.4)
- **Private to Public**: Traffic goes direct (no NVA)

## Cleanup

```bash
az group delete --name az104-rg-nva-routing --yes --no-wait
```