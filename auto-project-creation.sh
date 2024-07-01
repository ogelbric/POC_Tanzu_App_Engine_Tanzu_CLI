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
