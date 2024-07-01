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
