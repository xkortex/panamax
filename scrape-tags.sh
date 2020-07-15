i=0

IMAGE=${1:-nvidia/cuda}
CODE=0
mkdir -p "$(dirname /tmp/scrape-tags/$IMAGE)"
while [ "$CODE" == 0 ] && [ "$i" -lt 99 ]; do
  i=$((i+1))
  RES=$(curl -sS https://registry.hub.docker.com/v2/repositories/${IMAGE}/tags/\?page\=${i})
  CODE=$?
  TAGS=$(echo "$RES" | jq -r '."results"[]["name"]')
  if [[ $? -ne 0 ]]; then
    >&2 echo "failed to parse tags. full response:"
    >&2 echo "$RES"
    exit 1
  else
    echo "$TAGS" | tee -a /tmp/scrape-tags/$IMAGE.txt
  fi
  if [[ -z $TAGS ]]; then
    CODE=-1
  fi

done
