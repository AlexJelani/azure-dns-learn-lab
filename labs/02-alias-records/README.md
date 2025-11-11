# Lab 02: DNS Alias Records with Load Balancer

Create Azure DNS alias records pointing to a load balancer with multiple VMs.

## What it creates

- Resource Group: `dns-alias-rg`
- Virtual Network: `dns-vnet` (10.0.0.0/16)
- 2 Linux VMs: `vm1` and `vm2` running nginx
- Load Balancer: `dns-lb` with public IP `myPublicIP`
- DNS Zone: `wideworldimports111125.com`
- Alias A record at zone apex (`@`) pointing to load balancer

## Deployment Results

✅ **Successfully deployed 19 resources**
- Public IP: `203.0.113.10`
- DNS Name Servers: `ns1-XX.azure-dns.com.` (and 3 others)
- Test URL: `http://203.0.113.10`

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
# Output: 203.0.113.10
```

2. Test load balancer:
```bash
curl http://203.0.113.10
# <h1>Hello from VM2</h1>

curl http://203.0.113.10
# <h1>Hello from VM1</h1>
```

✅ **Load balancing confirmed** - Traffic alternates between VM1 and VM2

## DNS Verification

```bash
terraform output dns_zone_name_servers
# ns1-XX.azure-dns.com.
# ns2-XX.azure-dns.net.
# ns3-XX.azure-dns.org.
# ns4-XX.azure-dns.info.
```

The alias record at zone apex (`@`) automatically resolves to `203.0.113.10`

## Key Concepts

- **Alias Records**: Automatically update when target resource IP changes
- **Zone Apex**: Works at the root domain (unlike CNAME)
- **Load Balancing**: Distributes traffic across multiple VMs

## Cleanup

```bash
terraform destroy
```

**Cost**: ~$2-3/day for VMs and load balancer