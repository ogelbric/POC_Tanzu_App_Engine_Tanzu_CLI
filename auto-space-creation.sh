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
#
# List profile
tanzu profiles list
# List targets
tanzu availability-target list
#
export p1=orf-custom-networking
export p2=orfprofile1
export t1=orfstarget79
export sp="orf-auto-space3"
#

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
sed -i "s/spring-dev.tanzu.vmware.com/$p2/g"  auto-space.yaml
sed -i "s/my-custom-networking/$p1/g"  auto-space.yaml
sed -i "s/all-regions.tanzu.vmware.com/$t1/g"  auto-space.yaml
sed -i "s/my-first-space/$sp/g"  auto-space.yaml
cat auto-space.yaml
#
yes | tanzu deploy --only auto-space.yaml
tanzu space get $sp
#
