# Deploy proxy
TOKEN=$(gcloud auth print-access-token)
cd proxies/data-ai-services
zip -r data-ai-services.zip .
cd ../..
DEPLOYRESULT=$(apigeecli apis import -f ./proxies/data-ai-services -t $TOKEN -o bruno-1407a)
rm ./proxies/data-ai-services/data-ai-services.zip
REVISION=$(jq '.revision' <<< "$DEPLOYRESULT")
NEWREV="${REVISION%\"}"
NEWREV="${NEWREV#\"}"
apigeecli apis deploy -n data-ai-services -e test1 -s tyservice2@bruno-1407a.iam.gserviceaccount.com -v $NEWREV -r -o bruno-1407a -t $TOKEN

# Delete any previously deployed products
apigeecli products delete -n "Image API" -o bruno-1407a -t $TOKEN
apigeecli products delete -n "Text Analytics API" -o bruno-1407a -t $TOKEN
apigeecli products delete -n "Translation API" -o bruno-1407a -t $TOKEN

# Import API products
apigeecli products import -f ./products/ai-products.json -o bruno-1407a -t $TOKEN