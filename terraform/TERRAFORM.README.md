# Compress for Uploader
```
tar --exclude-vcs --exclude=terraform -zcvf  ./mqtt.ter.tgz ../

tar --exclude-vcs --exclude='../terraform' --exclude='../docs' --exclude=.env -zcvf  ./mqtt.ter.tgz ../
```
# Build AMI
```
packer build vm.pkr.hcl
```

# Plan for Terraform
```
terraform plan
```

# Provision Infra
```
terraform apply --auto-approve
```
# Login EC2 with pem key (Optional)
```
ssh -i KEY_NAME.pem ubuntu@PACKER_EIP
```

### MQTT Expolorer
```
PACKER_EIP:4000
```
### InfluxDB
```
PACKER_EIP:8086
```

# Clean up Infra
```
terraform destroy --auto-approve
```
