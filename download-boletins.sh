#!/bin/bash

function get_pdfs() {
    url=$1; shift
    path=$1

    HTML=arquivo.html

    curl -sSL -o $HTML $url
    echo "Recuperando lista de PDFs ..."
    for pdf_url in $(hxnormalize $HTML | hxwls 2> /dev/null | grep -i '.pdf' | grep -i -e 'leito' -e 'informe'); do
        pdf_filename=$(echo "$pdf_url" | sed 's/.*\///')

        find $path -name $pdf_filename > /dev/null
        if [ $? -eq 0 ]; then
            echo "$pdf_filename já baixado."
            continue
        fi

        echo "Baixando $pdf_url ..."
        (cd $path && curl -sSLO $pdf_url)

        YYYY_MM=$(pdfinfo -isodates "$path/$pdf_filename" | sed -e '/ModDate/!d;s/.*\([0-9]\{4\}\)-\([0-9]\{2\}\).*/\1-\2/')
        mkdir -p "$path/$YYYY_MM"

        mv $path/$pdf_filename $path/$YYYY_MM/$pdf_filename
    done

    rm $HTML

    echo "Feito."
}

get_pdfs "http://www.saude.al.gov.br/leitos-para-enfrentamento-da-covid-19" "./leitos"
get_pdfs "http://cidadao.saude.al.gov.br/saude-para-voce/coronavirus/" "./boletins"
