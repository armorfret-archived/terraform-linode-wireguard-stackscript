terraform-linode-wireguard-stackscript
=========

[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Terraform module that creates a [Linode](https://linode.com) Stackscript to deploy [wireguard](https://www.wireguard.com).

## Usage

```
module "stackscript" {
  source  = "github.com/armorfret/terraform-linode-wireguard-stackscript"
  image_ids = ["private/1234", "private/3456"]
}
```

## License

terraform-linode-wireguard-stackscript is released under the MIT License. See the bundled LICENSE file for details.
