#!/bin/bash

export DATE="202004"
export TABELAS="tbTipoEstabelecimento tbLeito rlEstabComplementar tbEstabelecimento "

echo "Baixando base de dados CNES (BASE_DE_DADOS_CNES_${DATE}.ZIP)"
wget -q -c -t 0 ftp://ftp.datasus.gov.br/cnes/BASE_DE_DADOS_CNES_${DATE}.ZIP
rm cnes.db

for tabela in $TABELAS; do
    echo "Descompactando ${tabela}${DATE}.csv ..."
    unzip -p BASE_DE_DADOS_CNES_${DATE}.ZIP ${tabela}${DATE}.csv | sed 's/\"//g' > ${tabela}.csv
    echo "Importando conteúdo na tabela ${tabela}..."
    echo ".import ${tabela}.csv ${tabela}" | sqlite3 -csv -separator ";" cnes.db
    rm ${tabela}.csv
done

echo "Finalizado!"