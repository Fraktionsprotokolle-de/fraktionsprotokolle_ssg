#!/bin/bash  # Add this shebang

echo "fetching transkriptions from data_repo"
rm -rf data/editions && mkdir data/editions
rm -rf data/indices && mkdir data/indices
rm -rf data/einleitungen && mkdir data/einleitungen
#rm -rf data/meta && mkdir data/meta
#curl -LO https://github.com/Fraktionsprotokolle-de/Protokolle/archive/refs/heads/main.zip
# Get Token from .env
TOKEN=$(grep TOKEN .env | cut -d '=' -f2)
# Get Repo from .env
REPO=$(grep REPO .env | cut -d '=' -f2)
# Get Asset ID from .env
ASSET_ID=$(grep ASSET_ID .env | cut -d '=' -f2)
# Get GITHUB_API_ENDPOINT from .env
GITHUB_API_ENDPOINT=$(grep GITHUB_API_ENDPOINT .env | cut -d '=' -f2)

# Echo ENV Variables
echo "TOKEN: $TOKEN"
echo "REPO: $REPO"
echo "ASSET_ID: $ASSET_ID"
echo "GITHUB_API_ENDPOINT: $GITHUB_API_ENDPOINT"

#curl -sLO --header "Authorization: token $TOKEN" --header 'Accept: application/octet-stream' https://$TOKEN:@$GITHUB_API_ENDPOINT/repos/$REPO/archive/refs/heads/main.zip -o main.zip
HTTP_CODE=$(curl -w "%{http_code}" -H "Authorization: token $TOKEN" \
     -L https://api.github.com/repos/$REPO/zipball/main \
     -o main.zip -s)

if [ "$HTTP_CODE" != "200" ]; then
    echo "❌ Error: Failed to download repository archive (HTTP $HTTP_CODE)"
    if [ "$HTTP_CODE" = "401" ]; then
        echo "   Authentication failed. Please check your TOKEN in .env file."
        echo "   The token may be expired or invalid."
        echo "   Generate a new token at: https://github.com/settings/tokens"
    elif [ "$HTTP_CODE" = "404" ]; then
        echo "   Repository not found or access denied."
        echo "   Please check REPO setting in .env: $REPO"
    fi
    cat main.zip 2>/dev/null
    rm -f main.zip
    exit 1
fi

echo "✅ Successfully downloaded repository archive"
topdir=$(unzip -Z1 main.zip | head -n1 | cut -d/ -f1)
unzip main.zip -d .

# Find all XML files and copy them to the destination directory
find "$topdir/Fraktionen" -type f -name "*.xml" \
    -not -path "*/Einleitung/*" \
    -not -path "*/Normdaten/*" \
    -not -path "*/__contents__.xml" \
    -exec sh -c 'cp "$1" ./data/editions/' _ {} \;
# Iterate over Subfolder Fraktionen and copy all directories to data/editions without the subfolder Einleitung and Normdaten
#for dir in "$topdir"/Fraktionen/*; do
#    base=$(basename "$dir")
#    if [ "$base" != "Einleitung" ] \
#       && [ "$base" != "Normdaten" ] \
#       && [ "$base" != "__contents__.xml" ]; then
#        mv "$dir" ./data/editions/
#    fi
#done

find "$topdir" -type f -name "*.xml" \
    -path "$topdir/Einleitung/*" \
    -not -path "*Normdaten*" \
    -exec cp {} ./data/einleitungen \;
find "$topdir" -type f -name "*.xml" -path "./Normdaten/*" -not -path "./Einleitung/*" -exec cp {} ./data/indices/ \;
for dir in $topdir/Fraktionen/Normdaten/*; do
        #Just copy the Files Organisationen.xml and Personen.xml to data/indices
        if [ "$(basename "$dir")" = "Organisationen.xml" ] || [ "$(basename "$dir")" = "Personen.xml" ]; then
                    mv "$dir" ./data/indices 
        fi
done

for dir in $topdir/Fraktionen/Einleitung/*; do
        #Just copy the Files Organisationen.xml and Personen.xml to data/indices
        #if [ "$(basename "$dir")" = "Organisationen.xml" ] || [ "$(basename "$dir")" = "Personen.xml" ]; then
                    mv "$dir" ./data/einleitungen
        #fi
done
#mv ./fraktionsprotokolle-data-main/data/editions/ ./data
#mv ./fraktionsprotokolle-data-main/Fraktionen//ind ./data/indices
#mv ./fraktionsprotokolle-data-main/data/meta/ ./data

rm main.zip
rm -rf ./Fraktionsprotokolle-de-Protokolle-*
