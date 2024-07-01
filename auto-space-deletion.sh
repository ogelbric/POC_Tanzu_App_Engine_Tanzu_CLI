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
export sp="orf-auto-space2"
#
yes | tanzu space delete $sp
