#!/bin/bash

# Source library
. ../utils/helper.sh
  
# Source demo-specific configurations
source config/demo.cfg

# Setup Azure container
export AZBLOB_ACCOUNT_NAME=$STORAGE_PROFILE
export AZBLOB_ACCOUNT_KEY=$(az storage account keys list --account-name $AZBLOB_ACCOUNT_NAME | jq -r '.[0].value')
az storage container show --name $STORAGE_BUCKET_NAME --account-name $AZBLOB_ACCOUNT_NAME --account-key $AZBLOB_ACCOUNT_KEY
if [[ $? != 0 ]]; then
  echo "az storage container create --name $STORAGE_BUCKET_NAME --account-name $AZBLOB_ACCOUNT_NAME --account-key $AZBLOB_ACCOUNT_KEY"
  az storage container create --name $STORAGE_BUCKET_NAME --account-name $AZBLOB_ACCOUNT_NAME --account-key $AZBLOB_ACCOUNT_KEY
fi

create_connector_cloud connectors/az_no_avro.json || exit 1

# While Azure Blob Sink is in Preview, limit is only one connector of this type
# So these lines are to remain commented out until then
#create_connector_cloud connectors/az_avro.json || exit 1

exit 0
