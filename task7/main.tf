provider "vault" {
 address = "http://192.168.0.87:8200"
 skip_tls_verify = true
 token = "education"
}

data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

data "vault_generic_secret" "my_secrets"{
 path = "secret/deeptop"
}

output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
}

output "my_secrets" {
 value = "${nonsensitive(data.vault_generic_secret.my_secrets.data)}"
}