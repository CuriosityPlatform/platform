package ddns

import (
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"kubernetes/common/core"
	"kubernetes/ddns/duckdns"
)

type Config struct {
	Token      string
	Subdomains []string
}

func Namespace(c Config) *core.Namespace {
	return &core.Namespace{
		Namespace: corev1.Namespace{
			TypeMeta: metav1.TypeMeta{
				Kind:       "Namespace",
				APIVersion: "v1",
			},
			ObjectMeta: metav1.ObjectMeta{
				Name: "ddns",
			},
		},
		ObjectsSlice: core.ObjectsSlice{
			duckdns.Deployment(duckdns.Config{
				Token:      c.Token,
				Subdomains: c.Subdomains,
			}),
		},
	}
}
