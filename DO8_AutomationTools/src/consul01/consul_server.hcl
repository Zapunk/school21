server = true
node_name = "consul_server"
advertise_addr = "192.168.56.10"
client_addr = "0.0.0.0"
data_dir = "/opt/consul"
bootstrap_expect = 1
ui = true

connect {
  enabled = true
}

ports {
  grpc = 8502
}