![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-oci-ampere-a1-DeathStarBench-DeathStarBench

[![Source Code](https://img.shields.io/badge/source-GitHub-blue.svg?style=flat)](https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench)
![documentation workflow](https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/actions/workflows/documentation.yml/badge.svg?label=build&style=flat-square&branch=main)
![release workflow](https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/actions/workflows/release.yml/badge.svg?label=build&style=flat-square&branch=main)
[![pages-build-deployment](https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/actions/workflows/pages/pages-build-deployment)
![nightly-build](https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/actions/workflows/nightly.yml/badge.svg?label=build&style=flat-square&branch=main)
[![Latest version](https://img.shields.io/github/tag/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench.svg?label=release&style=flat&maxAge=3600)](https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/tags)
[![GitHub issues](https://img.shields.io/github/issues/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench.svg)](https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/issues)
![Github stars](https://badgen.net/github/stars/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench?icon=github&label=stars)
![Github last-commit](https://img.shields.io/github/last-commit/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench)
[![GitHub forks](https://img.shields.io/github/forks/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench.svg)](https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/network)
![Github forks](https://badgen.net/github/forks/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench?icon=github&label=forks)
![GitHub License](https://img.shields.io/github/license/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![GitHub deployments](https://img.shields.io/github/deployments/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench/github-pages)
![Website](https://img.shields.io/website?url=https%3A%2F%2Famperecomputing.github.io/terraform-oci-ampere-a1-DeathStarBench)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

Terraform code to launch Ampere A1 Shapes on Oracle Cloud Infrastructure (OCI) which automatically deploy and runs [DeathStarBench](https://amperecomputing.com/en/briefs/dsb-sn-brief)

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/AmpereComputing/terraform-oci-ampere-a1-DeathStarBench-DeathStarBench/releases/download/latest/oci-ampere-a1-DeathStarBench-DeathStarBench-latest.zip)

## What is DeathStarBench?

DeathStarBench is an open-source benchmark suite for cloud microservices. DeathStarBench includes five end-to-end services, four for cloud systems, and one for cloud-edge systems running on drone swarms.
For the purposes of this automation we will be using the DeathStarBench "Social Media" application, which deploys a "Twitter" like social media web service utilizting containers.
For more information regarding Ampere platforms and DeathStarBench results please take a look at the following:

* [Ampere DeathStarBench workload Brief](https://amperecomputing.com/en/briefs/dsb-sn-brief)
* YouTube Videos:

[![Up to 44% Lower Latency on Ampere than x86 on DeathStarBench](https://img.youtube.com/vi/cGNEQRKB4qE/0.jpg)](https://www.youtube.com/watch?v=cGNEQRKB4qE "Up to 44% Lower Latency on Ampere than x86 on DeathStarBench")

[![Up to 73% Higher Performance and Better Consistency than x86 on DeathStarBench](https://img.youtube.com/vi/4b8yygZfP3c/0.jpg)](https://www.youtube.com/watch?v=4b8yygZfP3c "Up to 73% Higher Performance and Better Consistency than x86 on DeathStarBench")

## Requirements

 * [Terraform](https://www.terraform.io/downloads.html)
 * [Oracle OCI Account](https://www.oracle.com/cloud)


## Automation Walkthrough

This automation is essentially a spealized fork of the [terraform-oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) module adding additional configuration steps.
Thus this will configure all the networking and security settings for instances being deployed.  The instances being deployed have four cores and thirty two gigs of RAM. Essentially the remaining automation falls into two phases. 

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
