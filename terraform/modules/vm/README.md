
This module provisions an AZURE virtual machine with minikube installed.

## Usage

```hcl
module "<module name>" {
    source = "path of your module"
    bucket_name = "<UNIQ BUCKET NAME>"
    tags = {
        key   = "<value>"
    }
}
```
