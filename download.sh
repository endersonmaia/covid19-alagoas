#!/usr/bin/env sh

BOLETINS_HTML_FILE=boletins.html
BOLETINS_DOWNLOAD_PATH=./boletins

LEITOS_HTML_FILE=leitos.html
LEITOS_DOWNLOAD_PATH=./leitos

SINTOMAS_CSV_FILE="sintomas-$(date +%Y-%m-%d-%H:%M:%S.%s)"
SINTOMAS_DOWNLOAD_PATH=./sintomas

echo "Recuperando lista de PDFs para baixar..."
curl -sSL -o ${LEITOS_HTML_FILE} http://www.saude.al.gov.br/leitos-para-enfrentamento-da-covid-19/
curl -sSL -o ${BOLETINS_HTML_FILE} http://cidadao.saude.al.gov.br/saude-para-voce/coronavirus/
echo "Feito."

echo "Baixando PDFs dos boletins..."
for pdf in $(hxnormalize ${BOLETINS_HTML_FILE} | hxwls 2> /dev/null | grep -i pdf | grep -i informe); do
    filename=$(echo ${pdf} | sed 's/.*\///')
    [ -f "${BOLETINS_DOWNLOAD_PATH}/${filename}" ] && echo "${filename} já baixado." && continue
    echo "${filename} -> ${BOLETINS_DOWNLOAD_PATH}/ ..."
    (cd ${BOLETINS_DOWNLOAD_PATH} && curl -sSLO ${pdf})
done
rm ${BOLETINS_HTML_FILE}
echo "Feito."

echo "Baixando PDFs dos leitos..."
for pdf in $(hxnormalize ${LEITOS_HTML_FILE} | hxwls 2> /dev/null | grep -i 'pdf'); do
    filename=$(echo ${pdf} | sed 's/.*\///')
    [ -f "${LEITOS_DOWNLOAD_PATH}/${filename}" ] && echo "${filename} já baixado." && continue
    echo "${filename} -> ${LEITOS_DOWNLOAD_PATH}/ ..."
    (cd ${LEITOS_DOWNLOAD_PATH} && curl -sSLO ${pdf})
done
rm ${LEITOS_HTML_FILE}
echo "Feito."

echo "Baixando ultimo arquivo CSV de sintomas..."
curl -fsSL -o "${SINTOMAS_DOWNLOAD_PATH}/${SINTOMAS_CSV_FILE}.csv" https://envio.seplag.al.gov.br/covid19/public/dados/sintomas
if [ $? -eq "0" ]; then
    echo "Removendo duplicidades..."
    fdupes --delete --noprompt ${SINTOMAS_DOWNLOAD_PATH}
    echo "Feito."
else
    echo "Falha ao baixar CSV"
fi
