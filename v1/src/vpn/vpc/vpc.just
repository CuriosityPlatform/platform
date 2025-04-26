address := `gostore cat vps1/vm/vm53841/common address`
pass := `gostore cat vps1/vm/vm53841/common pass`
sshKeyPub := `gostore cat vps1/vm/ssh/vps1vm.pub`

sshpass := "sshpass -p" + pass
sshaddr := "root@" + address

ssh := "ssh " + sshaddr

[group('ssh')]
ssh-key-install:
    keyPath=~/.ssh/vps1vm.pub

    {{sshpass}} ssh-copy-id {{sshaddr}} -i $keyPath
    ssh-add $keyPath

[group('docker')]
docker-install:
    {{ssh}} -- "curl -fsSL https://get.docker.com | sh"
