# Deploy to Oracle Cloud Button# 

## Requirement for this 
* Github style SCM account,  
* schema.yaml
* .github/workflows/release.yml
  * actions/checkout@v2
  * oracle-devrel/action-release-zip-maker@v0.5
    * release_files.json
      * Removes and Replaces the provider.tf and the variables.tf with ones that exclude  user_ocid, fingerprint, and private_key_path.
      * Creates a zipfile named oci-ampere-a1-DeathStarBench-latest.zip" with all the files ending with "tf".
  * "marvinpinto/action-automatic-releases@latest
    * replaces previously released zipfile
