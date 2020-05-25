#!/usr/bin/env sh

BOLETINS_HTML_FILE=boletins.html
BOLETINS_DOWNLOAD_PATH=./boletins

LEITOS_HTML_FILE=leitos.html
LEITOS_DOWNLOAD_PATH=./leitos

echo "Recuperando lista de PDFs para baixar..."
curl -sSL -o ${LEITOS_HTML_FILE} http://www.saude.al.gov.br/leitos-para-enfrentamento-da-covid-19/
curl -sSL -o ${BOLETINS_HTML_FILE} http://cidadao.saude.al.gov.br/saude-para-voce/coronavirus/
echo "Feito."

echo "Baixando PDFs dos boletins..."
for pdf in $(hxnormalize ${BOLETINS_HTML_FILE} | hxwls 2> /dev/null | grep -i pdf | grep -i informe); do
    filename=$(echo "${pdf}" | sed 's/.*\///')
    year_month_path=$(pdfinfo -isodates "${pdf}" | sed -e '/ModDate/!d;s/.*\([0-9]\{4\}\)-\([0-9]\{2\}\).*/\1-\2/')
    filepath="${BOLETINS_DOWNLOAD_PATH}/${year_month_path}/${filename}"
    mkdir -p "${BOLETINS_DOWNLOAD_PATH}/${year_month_path}"

    [ -f "$filepath" ] && echo "${filepath} já baixado." && continue
    echo "Salvando em ${filepath} ..."
    (cd ${BOLETINS_DOWNLOAD_PATH}/$year_month_path && curl -sSLO ${pdf})
done
rm ${BOLETINS_HTML_FILE}
echo "Feito."

echo "Baixando PDFs dos leitos..."
for pdf in $(hxnormalize ${LEITOS_HTML_FILE} | hxwls 2> /dev/null | grep -i 'pdf'); do
    filename=$(echo "${pdf}" | sed 's/.*\///')
    year_month_path=$(pdfinfo -isodates "${pdf}" | sed -e '/ModDate/!d;s/.*\([0-9]\{4\}\)-\([0-9]\{2\}\).*/\1-\2/')
    filepath="${LEITOS_DOWNLOAD_PATH}/${year_month_path}/${filename}"
    mkdir -p "${LEITOS_DOWNLOAD_PATH}/${year_month_path}"

    [ -f "${filepath}" ] && echo "${filepath} já baixado." && continue
    echo "Salvando em ${filepath} ..."
    (cd ${LEITOS_DOWNLOAD_PATH}/${year_month_path} && curl -sSLO ${pdf})
done

rm "${LEITOS_HTML_FILE}"
rm "${BOLETINS_HTML_FILE}"

echo "Feito."
