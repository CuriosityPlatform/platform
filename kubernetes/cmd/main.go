package main

import (
	"encoding/json"
	"fmt"
	"os"

	"kubernetes/common/core"
	"kubernetes/ddns"
)

func main() {
	c := config()

	ddns := ddns.Namespace(ddns.Config{
		Token: c.DuckdnsToken,
		Subdomains: []string{
			c.StorageDomain,
		},
	})

	jsonEncoder := json.NewEncoder(os.Stdout)
	err := core.NewInlineMarshaller(jsonEncoder).Marshall(ddns)
	if err != nil {
		fmt.Println("ERR", err)
	}
}
