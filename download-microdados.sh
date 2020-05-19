#!/usr/bin/env sh

SINTOMAS_CSV_FILE="sintomas-$(date +%Y-%m-%d-%H:%M:%S.%s)"
SINTOMAS_DOWNLOAD_PATH=./sintomas

echo "Baixando ultimo arquivo CSV de sintomas..."
curl -fsSL -o "${SINTOMAS_DOWNLOAD_PATH}/${SINTOMAS_CSV_FILE}.csv" http://covid19.dados.al.gov.br/dados/sintomas
if [ $? -eq "0" ]; then
    echo "Removendo duplicidades..."
    fdupes --delete --noprompt ${SINTOMAS_DOWNLOAD_PATH}
    echo "Feito."
else
    echo "Falha ao baixar CSV"
fi
