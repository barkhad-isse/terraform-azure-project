environment = "dev"

allowed_ssh_source_ip = "46.212.32.254/32"

ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQjiqFRlIWBYSAV/balb6Sl4+DB/x+vwaLqSS913rPh bais001@egms.no"

vmss_instance_count = 1

tags = {
  owner   = "barkhad-isse"
  project = "terraform-azure-project"
  env     = "dev"
}
