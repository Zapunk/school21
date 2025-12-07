server = false
node_name = "{{ inventory_hostname }}"
advertise_addr = "{{ ansible_host }}"
client_addr = "0.0.0.0"
retry_join = ["192.168.56.10"]
data_dir = "/opt/consul"

connect {
  enabled = true
}

ports {
  grpc = 8502
}