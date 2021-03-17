resource "kubectl_manifest" "secret" {
    yaml_body = <<YAML
---
apiVersion: v1
kind: Secret
metadata:
  name: msecrets
type: Opaque
data:
  password: cm9vdA==
YAML
}

