# Lab 02: DNS Alias Records with Load Balancer

Create Azure DNS alias records pointing to a load balancer with multiple VMs.

## What it creates

- Resource Group: `dns-alias-rg`
- Virtual Network with 2 VMs running nginx
- Load Balancer with public IP
- DNS Zone with alias record at zone apex (`@`)

## Architecture

```
Internet → DNS Zone Apex → Load Balancer → VM1 or VM2
```

## Deployment

```bash
cd labs/02-alias-records
terraform init
terraform apply
```

## Testing

1. Get public IP:
```bash
terraform output public_ip
```

2. Test load balancer:
```bash
curl http://<public_ip>
```

You'll see responses from either VM1 or VM2.

## Key Concepts

- **Alias Records**: Automatically update when target resource IP changes
- **Zone Apex**: Works at the root domain (unlike CNAME)
- **Load Balancing**: Distributes traffic across multiple VMs

## Cleanup

```bash
terraform destroy
```

**Cost**: ~$2-3/day for VMs and load balancer