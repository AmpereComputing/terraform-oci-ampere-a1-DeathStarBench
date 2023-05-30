![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-oci-ampere-a1-DeathStarBench

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

Terraform code to launch Ampere A1 Shapes on Oracle Cloud Infrastructure (OCI) which automatically deploy and runs [DeathStarBench](https://amperecomputing.com/en/briefs/dsb-sn-brief)

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/releases/download/latest/oci-ampere-a1-DeathStarBench-latest.zip)

For more information regarding Ampere platforms and DeathStarBench results please take a look at the following:

* [Ampere DeathStarBench workload Brief](https://amperecomputing.com/en/briefs/dsb-sn-brief)
* [Up to 44% Lower Latency on Ampere than x86 on DeathStarBench](https://www.youtube.com/watch?v=cGNEQRKB4qE)
* [Up to 73% Higher Performance and Better Consistency than x86 on DeathStarBench](https://www.youtube.com/watch?v=4b8yygZfP3c)

## Requirements

 * [Terraform](https://www.terraform.io/downloads.html)
 * [Oracle OCI Account](https://www.oracle.com/cloud)


## Automation Walkthrough

This automation is essentially a spealized fork of the [terraform-oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) module adding additional configuration steps.
Thus this will configure all the networking and security settings for instances being deployed.  Essentially the remaining automation falls into two steps. 

1. Setup all the scaffolding and deploy two virtual machines passing different metadata into each host. 
   1. The first host will be deployed as the DeathStarBench social media application.
      1. The deployment includes a single node Kubernetes cluster with Calico for Kubernetes network.
      1. Once the Kubernetes infrastructure is running, Helm charts are used to deploy aarch64 container images from a public container repository.
   1. The second virtal machine instance will pull the DeathStarBench source and build the client worker to generate load against the deployed DeathStarBench social media application. 
      1. An Ngnix container is also deployed to allow the results of the load generation to be viewed via a simple HTML page.   
1. While the systems are executing thier metadata, two scripts are being rendered with the dynamic external IP information and copied via SCP to the running instances. 
   1. The rendering is done in order to faciliate connectivity to the DeathStarBench backend.
      1. Script ont he first node is used to load a default dataset into the DeathStarBench Social Media applicaiton after waiting for the application to be up and running.
      1. Build the Wrk2 client on the Second virtual machine instance from source, waiting until the DeathStarBench application is up and populated with data before executing the benchmark run.

## Configuration with terraform.tfvars

The easiest way to configure is to use a terraform.tfvars in the project directory.  
Please that Compartment OCID is NOT the same as Tenancy OCID for Root Compartment.
You will need to supply the appropriate compartment ID.

The following is an example of what terraform.tfvars should look like:

```
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopq"
user_ocid = "ocid1.user.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz0987654321zyxwvustqrponmlkj"
fingerprint = "a1:01:b2:02:c3:03:e4:04:10:11:12:13:14:15:16:17"
private_key_path = "/home/bwayne/.oci/oracleidentitycloudservice_bwayne-08-09-14-59.pem"
compartment_ocid = "ocid.compartment.oc1.aaaaaabbbbbbbcccccccddddddddd111111222222333333544444455"
# For development purposes if needed
# deathstarbench_repository_url = "-b <YOUR_BRANCH> https://oauth2:<YOURTOKEN>@gitlab.com/<YOUR_FORK>/DeathStarBench.git"

```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.oci-ssh-privkey](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.oci-ssh-pubkey](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.execute_wrk](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.populate_dsb_backend](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [oci_core_instance.ampere_a1](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.ampere_internet_gateway](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_route_table.ampere_route_table](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_security_list.ampere_security_list](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.ampere_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_virtual_network.ampere_vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_virtual_network) | resource |
| [random_uuid.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [tls_private_key.oci](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [oci_core_images.ubuntu-20_04-aarch64](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |
| [oci_identity_regions.regions](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_regions) | data source |
| [oci_identity_tenancy.tenancy](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tenancy) | data source |
| [template_file.dsb_populate](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.run_wrk](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ampere_a1_cpu_core_count"></a> [ampere\_a1\_cpu\_core\_count](#input\_ampere\_a1\_cpu\_core\_count) | Default core count for Ampere A1 instances in OCI Free Tier | `string` | `"4"` | no |
| <a name="input_ampere_a1_vm_memory"></a> [ampere\_a1\_vm\_memory](#input\_ampere\_a1\_vm\_memory) | Default RAM in GB for Ampere A1 instances in OCI Free Tier | `string` | `"32"` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | OCI Compartment ID | `any` | n/a | yes |
| <a name="input_deathstarbench_repository_url"></a> [deathstarbench\_repository\_url](#input\_deathstarbench\_repository\_url) | DeathStarBench repository url | `string` | `"-b arm64-port https://github.com/AmpereComputing/DeathStarBench.git"` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | OCI Fingerprint ID for Free-Tier Account | `any` | n/a | yes |
| <a name="input_instance_prefix"></a> [instance\_prefix](#input\_instance\_prefix) | Name prefix for vm instances | `string` | `"dsb"` | no |
| <a name="input_oci_vcn_cidr_block"></a> [oci\_vcn\_cidr\_block](#input\_oci\_vcn\_cidr\_block) | CIDR Address Block for OCI Networks | `string` | `"10.1.0.0/16"` | no |
| <a name="input_oci_vcn_cidr_subnet"></a> [oci\_vcn\_cidr\_subnet](#input\_oci\_vcn\_cidr\_subnet) | CIDR Subnet Address for OCI Networks | `string` | `"10.1.1.0/24"` | no |
| <a name="input_oci_vm_count"></a> [oci\_vm\_count](#input\_oci\_vm\_count) | OCI Free Tier Ampere A1 is four instances | `number` | `2` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Local path to the OCI private key file | `any` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCI Tenancy ID for Free-Tier Account | `any` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | OCI User ID for Free-Tier Account | `any` | n/a | yes |
| <a name="input_wrk_duration"></a> [wrk\_duration](#input\_wrk\_duration) | duration to use when running wrk | `string` | `"30s"` | no |
| <a name="input_wrk_number_of_conns"></a> [wrk\_number\_of\_conns](#input\_wrk\_number\_of\_conns) | Number of connections to use when running wrk | `string` | `"1000"` | no |
| <a name="input_wrk_number_of_threads"></a> [wrk\_number\_of\_threads](#input\_wrk\_number\_of\_threads) | Number of Threads to use when running wrk | `string` | `"10"` | no |
| <a name="input_wrk_requests_per_second"></a> [wrk\_requests\_per\_second](#input\_wrk\_requests\_per\_second) | Number of requests per second to use when running wrk | `string` | `"5000"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AmpereA1_DeathStarBench_BootVolumeIDs"></a> [AmpereA1\_DeathStarBench\_BootVolumeIDs](#output\_AmpereA1\_DeathStarBench\_BootVolumeIDs) | Output the boot volume IDs of the instance |
| <a name="output_AmpereA1_DeathStarBench_PrivateIPs"></a> [AmpereA1\_DeathStarBench\_PrivateIPs](#output\_AmpereA1\_DeathStarBench\_PrivateIPs) | Output the private IP(s) of the instance(s) |
| <a name="output_AmpereA1_DeathStarBench_PublicIPs"></a> [AmpereA1\_DeathStarBench\_PublicIPs](#output\_AmpereA1\_DeathStarBench\_PublicIPs) | Output the public IP(s) of the instance(s) |
| <a name="output_AmpereA1_DeathStarBench_RESULTS_URL"></a> [AmpereA1\_DeathStarBench\_RESULTS\_URL](#output\_AmpereA1\_DeathStarBench\_RESULTS\_URL) | Output the URL of the WRK2 Output/Results |
| <a name="output_AmpereA1_DeathStarBench_URL"></a> [AmpereA1\_DeathStarBench\_URL](#output\_AmpereA1\_DeathStarBench\_URL) | Output the url of the DeathStarBench application |
| <a name="output_OCI_Availability_Domains"></a> [OCI\_Availability\_Domains](#output\_OCI\_Availability\_Domains) | Output Availability Domain Results |
| <a name="output_Ubuntu-20_04-aarch64-latest_name"></a> [Ubuntu-20\_04-aarch64-latest\_name](#output\_Ubuntu-20\_04-aarch64-latest\_name) | Output the Ubuntu 20.04 image name |
| <a name="output_Ubuntu-20_04-aarch64-latest_ocid"></a> [Ubuntu-20\_04-aarch64-latest\_ocid](#output\_Ubuntu-20\_04-aarch64-latest\_ocid) | Output the Ubuntu 20.04 image OCID |
| <a name="output_oci_home_region"></a> [oci\_home\_region](#output\_oci\_home\_region) | Output the OCI Home Region |
| <a name="output_oci_ssh_private_key"></a> [oci\_ssh\_private\_key](#output\_oci\_ssh\_private\_key) | Output OCI SSH Private Key |
| <a name="output_oci_ssh_public_key"></a> [oci\_ssh\_public\_key](#output\_oci\_ssh\_public\_key) | Output OCI SSH Public Key |
<!-- END_TF_DOCS -->


## References

* [https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm)
* [Where to Get the Tenancy's OCID and User's OCID](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five)
* [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth)
* [Instance Principal Authorization](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#instancePrincipalAuth)
* [Security Token Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#securityTokenAuth)
* [How to Generate an API Signing Key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two)
* [Bootstrapping a VM image in Oracle Cloud Infrastructure using Cloud-Init](https://martincarstenbach.wordpress.com/2018/11/30/bootstrapping-a-vm-image-in-oracle-cloud-infrastructure-using-cloud-init/)
* [Oracle makes building applications on Ampere A1 Compute instances easy](https://blogs.oracle.com/cloud-infrastructure/post/oracle-makes-building-applications-on-ampere-a1-compute-instances-easy?source=:ow:o:p:nav:062520CloudComputeBC)
* [scross01/oci-linux-instance-cloud-init.tf](https://gist.github.com/scross01/5a66207fdc731dd99869a91461e9e2b8)
* [scross01/autonomous_linux_7.7.tf](https://gist.github.com/scross01/bcd21c12b15787f3ae9d51d0d9b2df06)
* [Oracle Cloud Always Free](https://www.oracle.com/cloud/free/#always-free)
* [OCI Terraform Level 200](https://www.oracle.com/a/ocom/docs/terraform-200.pdf)
* [OCI Stacks](https://docs.oracle.com/en/cloud/paas/cloud-stack-manager/csmug/oracle-cloud-stack-manager.html#GUID-CE12A1EA-7AB9-4ED2-B63F-553EA9C2CC1D)
* [An Open-Source Benchmark Suite for Microservices and Thier Hardware-Software Implications for Cloud & Edge Systems](https://www.csl.cornell.edu/~delimitrou/papers/2019.asplos.microservices.pdf)
* [The Morning Paper: An open-source benchmark suite for microservices and their hardware-software implications for cloud & edge systems](https://blog.acolyer.org/2019/05/13/an-open-source-benchmark-suite-for-microservices-and-their-hardware-software-implications-for-cloud-edge-systems/)
* [Ampere DeathStarBench workload Brief](https://amperecomputing.com/en/briefs/dsb-sn-brief)
* [Up to 44% Lower Latency on Ampere than x86 on DeathStarBench](https://www.youtube.com/watch?v=cGNEQRKB4qE)
* [Up to 73% Higher Performance and Better Consistency than x86 on DeathStarBench](https://www.youtube.com/watch?v=4b8yygZfP3c)
