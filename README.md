# fydp

## Obtain Access Token:

curl https://api.spark.io/oauth/token -u spark:spark -d grant_type=password -d username=garyguo110@gmail.com -d password=Rasberryboat

## Example Access Token:
a2f7137f16df99332448d22d8bc866eaaee150ea

## Set States to LIGHT or SWITCH

curl https://api.spark.io/v1/devices/53ff6a066667574829572567/setState \
  -d access_token=a2f7137f16df99332448d22d8bc866eaaee150ea \
  -d params=LIGHT

curl https://api.spark.io/v1/devices/54ff6c066667515128301467/setState \
  -d access_token=a2f7137f16df99332448d22d8bc866eaaee150ea \
  -d params=SWITCH

## Assign cores(lights) to a SWITCH core

curl https://api.spark.io/v1/devices/54ff6c066667515128301467/setCores \
  -d access_token=79c822b771c0432a618a480f0fc01b50842c1b52 \
  -d params=53ff6a066667574829572567

## Get the state of a core
curl https://api.spark.io/v1/devices/53ff6a066667574829572567/state?access_token=a2f7137f16df99332448d22d8bc866eaaee150ea

curl https://api.spark.io/v1/devices/54ff6c066667515128301467/state?access_token=a2f7137f16df99332448d22d8bc866eaaee150ea

## Get the assigned cores
curl https://api.spark.io/v1/devices/54ff6c066667515128301467/pairedCores?access_token=a2f7137f16df99332448d22d8bc866eaaee150ea

## Digital Flip a switch
curl -H "Authorization: Bearer a2f7137f16df99332448d22d8bc866eaaee150ea" \
    https://api.spark.io/v1/events/flip_switch
