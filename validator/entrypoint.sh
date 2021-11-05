#!/bin/bash

# Paths
AUTH_TOKEN_DIR="/root/.eth2validators"
AUTH_TOKEN_FILE="${AUTH_TOKEN_DIR}/auth-token"

# Generate JWT
# --wallet-dir value   Path to a wallet directory on-disk for Prysm validator accounts (default: "/root/.eth2validators/prysm-wallet-v2")
validator web generate-auth-token --wallet-dir=${AUTH_TOKEN_DIR} --accept-terms-of-use

# Check if the file exists
if [ -f "${AUTH_TOKEN_FILE}" ]; then
    # Post JWT to dappmanager
    curl -X POST "http://my.dappnode/data-send?key=token&data=$(sed -n 2p ${AUTH_TOKEN_FILE})" || echo "Error posting the auth-token"
else
    echo "Could not find auth token file"
fi

# Must used escaped \"$VAR\" to accept spaces: --graffiti=\"$GRAFFITI\"
exec -c validator \
  --prater \
  --datadir=/root/.eth2 \
  --rpc-host 0.0.0.0 \
  --monitoring-host 0.0.0.0 \
  --beacon-rpc-provider=\"$BEACON_RPC_PROVIDER\" \
  --beacon-rpc-gateway-provider=\"$BEACON_RPC_GATEWAY_PROVIDER\" \
  --wallet-dir=/root/.eth2validators \
  --wallet-password-file=/root/.eth2wallets/wallet-password.txt \
  --write-wallet-password-on-web-onboarding \
  --graffiti=\"$GRAFFITI\" \
  --web \
  --grpc-gateway-host=0.0.0.0 \
  --grpc-gateway-port=80 \
  --accept-terms-of-use \
  $EXTRA_OPTS