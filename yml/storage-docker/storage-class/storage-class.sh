#! /bin/bash

### Storage Classes ###

# PV to PVC binding # requirments:
# sufficient capacity   *****
# access modes          *****
# storage class         ***** 
# volume mode           ***** 
# selectors             ***** 

# When using cloud storage, the storage needs to be created 
# before the PV can be created.
## Static Provisioning ##

# This is where storage classes are used to provision the storage.