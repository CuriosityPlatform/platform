healthcheck {
    address = "0.0.0.0:8080"
    path    = "/healthz"
}

tcpproxy ":80" {
    destination = "127.0.0.1:3000"
}

tcpproxy ":443" {
    destination = "127.0.0.1:3000"
}