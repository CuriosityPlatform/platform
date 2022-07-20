package duckdns

import (
	"strings"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"kubernetes/common/maybe"
)

type Config struct {
	Token      string
	Subdomains []string
}

func Deployment(c Config) *appsv1.Deployment {
	labels := map[string]string{
		"app": "duckdns",
	}

	return &appsv1.Deployment{
		TypeMeta: metav1.TypeMeta{
			Kind:       "Deployment",
			APIVersion: "apps/v1",
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:   "duckdns",
			Labels: labels,
		},
		Spec: appsv1.DeploymentSpec{
			Replicas: maybe.Ptr(maybe.NewJust(int32(1))),
			Selector: &metav1.LabelSelector{
				MatchLabels: labels,
			},
			Template: corev1.PodTemplateSpec{
				Spec: corev1.PodSpec{
					Containers: []corev1.Container{
						{
							Name:            "duckdns",
							Image:           "lscr.io/linuxserver/duckdns:latest",
							ImagePullPolicy: corev1.PullIfNotPresent,
							Env: []corev1.EnvVar{
								{
									Name:  "SUBDOMAINS",
									Value: strings.Join(c.Subdomains, ","),
								},
								{
									Name:  "TOKEN",
									Value: c.Token,
								},
							},
						},
					},
				},
			},
		},
	}
}
