package main

func config() Config {
	c := encConfig()

	return Config{
		StorageDomain: "storage-makerovspace",
		DuckdnsToken:  c.DuckdnsToken,
	}
}

type Config struct {
	StorageDomain string
	DuckdnsToken  string
}
