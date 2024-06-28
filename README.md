# Tanzu Platoform / Tanzu CLI

This will try to answer if all the 3 previous of my write ups can be done via Tanzu CLI commands

# Create a Tanzu Platform Space

Env setup and login
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


