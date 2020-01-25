# kustomize-sops

A plugin for [kustomize](https://kustomize.io/) to generate secrets from [sops](https://github.com/mozilla/sops) encrypted files.

## Requirements

The plugin requires `python` and `PyYAML` library.

## Install

    bash install.sh

This will copy the plugin to $XDG_CONFIG_HOME directory.

## Usage

There are three different ways to generate a secret:

* from encrypted dotenv files (`KEY=VALUE`, one per line),
* from an encrypted file,
* from literal values inside the kustomization file itself.

### Example
Use sops to encrypt some secrets as a dotenv file:

```
sops foo.env
```

Use sops to encrypt a text file:

```
sops secretfile.txt
```

Make a kustomization resource file referring to the above secrets and also
defining some additional key value pairs:

```
cat << EOF > secret.yml
apiVersion: barlik/v1
kind: SopsSecret
metadata:
  name: mysecret
  labels:
    security: high
  annotations:
    kustomize.config.k8s.io/needs-hash: "false"
envs:
  - foo.env
files:
  - secretfile.txt
literals:
  - DB_USERNAME=admin
  - DB_SERVER=localhost
EOF
```

Add the secrets generator to the kustomization.yml file:

```
cat << EOF > kustomization.yml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
generators:
  - secret.yml
EOF
```

And finally, run kustomize build to generate the secret:

> ```
> apiVersion: v1
> kind: Secret
> metadata:
>   name: mysecret
>   labels:
>     security: high
> stringData:
>   DB_USERNAME: admin
>   DB_SERVER: localhost
>   secretfile.txt: <unencrypted contents from secretfile.txt>
>   KEY: VALUE <key value pairs from dotenv file>
>   ...
> ```
