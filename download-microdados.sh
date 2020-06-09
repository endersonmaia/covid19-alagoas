#!/usr/bin/env sh

SINTOMAS_CSV_FILE="sintomas-$(date +%Y-%m-%d-%H)h"
SINTOMAS_BASE_PATH="./sintomas"
SINTOMAS_DOWNLOAD_PATH="$SINTOMAS_BASE_PATH/$(date +%Y-%m)/$(date +%Y-%m-%d)"

mkdir -p ${SINTOMAS_DOWNLOAD_PATH}

echo "Baixando ultimo arquivo CSV de sintomas..."
curl -fsSL -o "${SINTOMAS_DOWNLOAD_PATH}/${SINTOMAS_CSV_FILE}.csv" https://covid19.dados.al.gov.br/sintomas
if [ $? -eq "0" ]; then
    echo "Removendo duplicidades..."
    fdupes --recurse --delete --noprompt ${SINTOMAS_BASE_PATH}
    echo "Feito."
else
    echo "Falha ao baixar CSV"
fi
