healthcheck {
    address = "0.0.0.0:8080"
    path    = "/healthz"
}

server ":80" {
    limit {
        # allow 10 RPS burst up to 20
        rps = 10
        burst = 20
    }

    downstream cluster {
        upstream = "cluster"

        rule host {
            host = "makeroff.ru"
        }
    }

    upstream cluster {
        address = "http://localhost:3000"
    }
}