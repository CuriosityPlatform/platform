local images = import 'images.jsonnet';

local copy = std.native('copy');
local copyFrom = std.native('copyFrom');
local secret = std.native('secret');

local sources = [
    "components",
    "homelab",
];

{
    project(envs):: {
        apiVersion: "brewkit/v1",

        targets: {
            [env+"-generate"]: {
                from: images.os,
                workdir: "/app",
                copy: [copy(source, source) for source in sources] +
                [
                    copyFrom(
                        "kubectl",
                        "/usr/local/bin/k",
                        "/usr/local/bin/k"
                    )
                ],
                command: std.format("k kustomize %s > dist.yaml", [env]),
                output: {
                    artifact: "/app/dist.yaml",
                    "local": "./out",
                },
            }
            for env in envs // expand build target for each envs
        } + {
            [env+"-deploy"]: {
                from: images.os,
                workdir: "/app",
                dependsOn: [env+"-generate"],
                secret: secret("kubeconfig", "/root/.kube/config"),
                // gathering kubectl
                copy: [
                    copyFrom(
                        "kubectl",
                        "/usr/local/bin/k",
                        "/usr/local/bin/k"
                    ),
                    copy("out/dist.yaml", "out/dist.yaml"),
                ],
                network: "host",
                command: "k apply -f out/dist.yaml",
            }
            for env in envs // expand build target for each envs
        } + {
            kubectl: {
                from: "scratch",
                workdir: "/app",
                copy: copyFrom(
                    images.kubectl,
                    "/opt/bitnami/kubectl/bin/kubectl",
                    "/usr/local/bin/k"
                ),
            },
        },
    },
}
