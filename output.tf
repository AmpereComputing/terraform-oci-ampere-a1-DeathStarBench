# Output the private IP(s) of the instance(s)
output "AmpereA1_DeathStarBench_PrivateIPs" {
  value = ["${oci_core_instance.ampere_a1.*.private_ip}"]
}

# Output the public IP(s) of the instance(s)
output "AmpereA1_DeathStarBench_PublicIPs" {
  value = ["${oci_core_instance.ampere_a1.*.public_ip}"]
}

# Output the url of the DeathStarBench application
output "AmpereA1_DeathStarBench_URL" {
  value = ["http://${oci_core_instance.ampere_a1.0.public_ip}:32080"]
}

# Output the URL of the WRK2 Output/Results
output "AmpereA1_DeathStarBench_RESULTS_URL" {
  value = ["http://${oci_core_instance.ampere_a1.1.public_ip}"]
}

# Output the boot volume IDs of the instance
output "AmpereA1_DeathStarBench_BootVolumeIDs" {
  value = ["${oci_core_instance.ampere_a1.*.boot_volume_id}"]
}
