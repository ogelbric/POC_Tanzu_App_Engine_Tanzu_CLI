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
