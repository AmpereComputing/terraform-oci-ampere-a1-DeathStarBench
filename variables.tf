# User/Tenant authentication variables
variable "tenancy_ocid" {
    description = "OCI Tenancy ID for Free-Tier Account"
}

variable "user_ocid" {
    description = "OCI User ID for Free-Tier Account"
}
variable "fingerprint" {
    description = "OCI Fingerprint ID for Free-Tier Account"
}

variable "private_key_path" {
    description = "Local path to the OCI private key file"
}

# Network Configuration Variables

variable "oci_vcn_cidr_block" {
    default     = "10.1.0.0/16"
    description = "CIDR Address Block for OCI Networks"
}

variable "oci_vcn_cidr_subnet" {
    default     = "10.1.1.0/24"
    description = "CIDR Subnet Address for OCI Networks"
}

# Virtual Machine Configuration Variables

variable "instance_prefix" {
  description = "Name prefix for vm instances"
  default = "dsb"
}

# OCI Free Tier Ampere A1 provides 4 cores and  24G of memory.
# This can be broken up between up to 4 virtual machines.
#  * 1 vm 24G 4 cores
#  * 2 vm 12G 2 cores
#  * 4 vm 6G 1 cores

variable "oci_vm_count" {
  description = "OCI Free Tier Ampere A1 is four instances"
  default = 2
}
variable "ampere_a1_vm_memory" {
    default = "12"
    description = "Default RAM in GB for Ampere A1 instances in OCI Free Tier"
    type    = string
}
variable "ampere_a1_cpu_core_count" {
    default = "2"
    description = "Default core count for Ampere A1 instances in OCI Free Tier"
    type    = string
}
variable deathstarbench_repository_url {
#   default = "https://github.com/delimitrou/DeathStarBench.git"
    default = "-b arm64-port https://github.com/AmpereComputing/deathstarbench-ah.git DeathStarBench"
    type    = string
    description = "DeathStarBench repository url"
}
variable "wrk_number_of_threads" {
#   default = "10"
    default = "2"
    description = "Number of Threads to use when running wrk"
    type    = string
}
variable "wrk_number_of_conns" {
#   default = "1000"
    default = "100"
    description = "Number of connections to use when running wrk"
    type    = string
}
variable "wrk_duration" {
    default = "30s"
    description = "duration to use when running wrk"
    type    = string
}
variable "wrk_requests_per_second" {
#   default = "5000"
    default = "50"
    description = "Number of requests per second to use when running wrk"
    type    = string
}
