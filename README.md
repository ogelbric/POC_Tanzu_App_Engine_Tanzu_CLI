# Tanzu Platform / Tanzu CLI

This will try to answer if all the 3 previous of my write ups can be done via Tanzu CLI commands

* (1) Create a Tanzu Platform Project
* (2) Create a Tanzu Platform Profile
* (3) Create a Tanzu Platform Profile Networking
* (4) Create a Tanzu Platform Space


## Create a Tanzu Platform Project

```
 cat auto-project-creation.sh
export proj="orf-auto-project"
export org="sa-tanzu-platform"
#export cl="orfclustergroup"
export sp="orf-auto-space1"
export w=''
#export w='--wide'
export line="-----------------------------------------------------------------"
yes | tanzu context delete $org
source ~/tanzucli.src
tanzu login
#
export p1=orf-custom-networking
export p2=orfprofile1
export t1=orfstarget79
export sp="orf-auto-space3"
#
tanzu project unset

cat <<EOF >auto-project.yaml
---
apiVersion: ucp.tanzu.vmware.com/v1
kind: Project
metadata:
  name: orf-project
spec:
  lastModifiedDate: null
EOF
#
sed -i "s/orf-project/$proj/g"  auto-project.yaml
cat auto-project.yaml
#
tanzu project create -f auto-project.yaml
#yes | tanzu project create -f auto-project.yaml
tanzu project use $proj
#
```
## Create a Tanzu Platform Profile 

```
export proj="AMER-East"
export org="sa-tanzu-platform"
#export cl="orfclustergroup"
export w=''
#export w='--wide'
export line="-----------------------------------------------------------------"
yes | tanzu context delete $org
source ~/tanzucli.src
tanzu login
tanzu project use $proj
#
export p1=orf-custom-networking
export p2=orfprofile1
export t1=orfstarget79
export sp="orf-auto-space3"
export prof="orf-auto-profile2"
#

cat <<EOF >auto-profile.yaml
---
apiVersion: spaces.tanzu.vmware.com/v1alpha1
kind: Profile
metadata:
  name: orf-auto-profile1
  namespace: default
spec:
  requiredCapabilities:
  - name: certificates.tanzu.vmware.com
  - name: container-app.tanzu.vmware.com
  - name: package-management.tanzu.vmware.com
  - name: k8sgateway.tanzu.vmware.com
  traits:
  - alias: carvel-package-installer.tanzu.vmware.com
    name: carvel-package-installer.tanzu.vmware.com
    values:
      inline:
        carvel-package-installer:
          serviceAccountName: carvel-package-installer
EOF
#
sed -i "s/orf-auto-profile1/$prof/g"  auto-profile.yaml
cat auto-space.yaml
#
yes | tanzu profile create -f auto-profile.yaml
tanzu profile get  $prof
#
```

## Create Tanzu Platform Network Profile

```
export proj="AMER-East"
export org="sa-tanzu-platform"
#export cl="orfclustergroup"
export w=''
#export w='--wide'
export line="-----------------------------------------------------------------"
yes | tanzu context delete $org
source ~/tanzucli.src
tanzu login
tanzu project use $proj
#
export p1=orf-custom-networking
export p2=orfprofile1
export t1=orfstarget79
export sp="orf-auto-space3"
export prof="orf-auto-profile-network2"
#

cat <<EOF >auto-profile-network.yaml
---
apiVersion: spaces.tanzu.vmware.com/v1alpha1
kind: Profile
metadata:
  name: orf-auto-profile1
  namespace: default
spec:
  requiredCapabilities:
  - name: egress.tanzu.vmware.com
  - name: certificates.tanzu.vmware.com
  - name: multicloud-ingress.tanzu.vmware.com
  traits:
  - alias: egress.tanzu.vmware.com
    name: egress.tanzu.vmware.com
    values:
      inline: null
  - alias: multicloud-cert-manager.tanzu.vmware.com
    name: multicloud-cert-manager.tanzu.vmware.com
    values:
      inline: null
  - alias: multicloud-ingress.tanzu.vmware.com
    name: multicloud-ingress.tanzu.vmware.com
    values:
      inline: nullEOF
#
sed -i "s/orf-auto-profile1/$prof/g"  auto-profile-network.yaml
cat auto-profile-network.yaml
#
yes | tanzu profile create -f auto-profile-network.yaml
tanzu profile get  $prof
#
```

## Create a Tanzu Platform Space

### Env setup and login
```
export proj="AMER-East"
export org="sa-tanzu-platform"
#export cl="orfclustergroup"
export sp="orf-auto-space1"
export w=''
#export w='--wide'
export line="-----------------------------------------------------------------"
yes | tanzu context delete $org
source ~/tanzucli.src
tanzu login
tanzu project use $proj
export sp="orf-auto-space1"
#
```
### Get the profile and Targets

```
tanzu profiles list
#orf-custom-networking
#orfprofile1
#
tanzu availability-target list
#orfstarget79
#
```
### Create Tanzu Platfom Space

```
cat <<EOF >auto-space.yaml
 apiVersion: spaces.tanzu.vmware.com/v1alpha1
 kind: Space
 metadata:
   name: my-first-space
 spec:
   template:
     spec:
       profiles:
       - name: spring-dev.tanzu.vmware.com
       - name: my-custom-networking
       resources:
         limits:
           cpu: 5000m
           memory: 10Gi
   availabilityTargets:
   - name: all-regions.tanzu.vmware.com
     replicas: 1
   updateStrategy:
     type: Recreate
EOF
#
```

### Modify the Tanzu Platform Space and deploy

```
sed -i 's/spring-dev.tanzu.vmware.com/orfprofile1/g'  auto-space.yaml
sed -i 's/my-custom-networking/orf-custom-networking/g'  auto-space.yaml
sed -i 's/all-regions.tanzu.vmware.com/orfstarget79/g'  auto-space.yaml
sed -i 's/my-first-space/orf-auto-space1/g'  auto-space.yaml
cat auto-space.yaml
#
yes | tanzu deploy --only auto-space.yaml
tanzu space get $sp
```
### Tanzu Platform Space delete

```
tanzu space delete orf-auto-space1
```


Docs used
```
https://github.com/Tanzu-Solutions-Engineering/tanzu-platform-workshop/blob/main/advanced-topics/helm-charts-dockerfiles.md
https://docs.vmware.com/en/VMware-Tanzu-Platform/services/create-manage-apps-tanzu-platform-k8s/getting-started-create-app-envmt.html
```
