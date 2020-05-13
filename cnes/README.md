# CNES - Cadastro Nacional de Estabelecimentos de Saúde

Aqui utilizamos a fonte de dados do CNES do Min. da Saúde para poder compilar quais estabalecimentos disponbibilizam leitos que podem ser usados para o COVID-19 e comparar com os boletins do Estado.

## Requisitos

* bash
* sqlite3
* sed
* wget
* unzip

## Executando

Com os requisitos preenchidos, basta executar :

```shell
$ ./load_cnes.sh
Baixando base de dados CNES (BASE_DE_DADOS_CNES_202003.ZIP)
Descompactando tbTipoEstabelecimento202003.csv ...
Importando conteúdo na tabela tbTipoEstabelecimento...
Descompactando tbLeito202003.csv ...
Importando conteúdo na tabela tbLeito...
Descompactando rlEstabComplementar202003.csv ...
Importando conteúdo na tabela rlEstabComplementar...
Descompactando tbEstabelecimento202003.csv ...
Importando conteúdo na tabela tbEstabelecimento...
Finalizado!
```

## Listando leitos para COVID-19 em Alagoas

Segue consulta para buscar todos os estabelecimentos com leitos especiais para COVID-19.

De acordo com o CNES, os leitos de UTI para COVID-19 são os de código `51` e `52`, e o código do Estado de Alagoas é o `27`. Estes códigos estão fixos na consulta de exemplo as seguir :


```shell
$ cat <<EOF | sqlite3 -csv -header cnes.db
SELECT
      E.CO_UNIDADE
    , E.CO_CNES
    , E.NO_FANTASIA
    , E.CO_CEP
    , C.QT_EXIST
    , L.CO_LEITO
    , L.DS_LEITO
FROM tbEstabelecimento E
JOIN rlEstabComplementar C ON (E.CO_UNIDADE = C.CO_UNIDADE)
JOIN tbLeito L ON (C.CO_LEITO = L.CO_LEITO)
WHERE L.CO_LEITO IN ('51', '52')
AND E.CO_ESTADO_GESTOR = '27';
EOF
CO_UNIDADE,CO_CNES,NO_FANTASIA,CO_CEP,QT_EXIST,CO_LEITO,DS_LEITO
2700302005050,2005050,"HOSPITAL REGIONAL DE ARAPIRACA",57300080,2,51,"UTI II ADULTO - COVID-19"
2704302006359,2006359,"HOSPITAL SANATORIO",57025060,15,51,"UTI II ADULTO - COVID-19"
2704309923837,9923837,"HOSPITAL DA MULHER DRA NISE DA SILVEIRA",57025200,49,51,"UTI II ADULTO - COVID-19"
2704309923837,9923837,"HOSPITAL DA MULHER DRA NISE DA SILVEIRA",57025200,5,52,"UTI II PEDIATRICA - COVID-19"
2702302010356,2010356,"CARVALHO BELTRAO SERVICOS DE SAUDE LTDA",57230000,15,51,"UTI II ADULTO - COVID-19"
2704302006448,2006448,"HOSPITAL VEREDAS",57050000,20,51,"UTI II ADULTO - COVID-19"
2704302006960,2006960,"HOSPITAL VIDA",57035240,3,51,"UTI II ADULTO - COVID-19"
2700303015408,3015408,"UNIDADE DE EMERGENCIA DR DANIEL HOULY",57315745,7,51,"UTI II ADULTO - COVID-19"
2704302006197,2006197,"HOSPITAL UNIVERSITARIO PROF ALBERTO ANTUNES",57072900,6,51,"UTI II ADULTO - COVID-19"
```