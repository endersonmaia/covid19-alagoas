# COVID-19 Alagoas

O repositório contém scripts para baixar todos os boletins informativos do COVID-19 do Estado de Alagoas, bem como os boletinms de ocupação de leitos.

## Objetivos

 - [X] Baixar e manter cópia dos boletins no repositório
 - [ ] Automatizar download periódico dos boletins e publicação no repositório
 - [ ] Manter arquivos CSV com dados sobre confirmados e óbitos
 - [ ] Manter arquivos CSV com dados de ocupação de leitos
 - [ ] Automatizar coleta de dados para geração do CSV

## Scripts

### download.sh

Este script faz o download de todos os boletins.

Requisitos :

 - html-xml-utils


```shell
$> ./download.sh
Recuperando lista de PDFs para baixar...
Feito.
Baixando PDFs dos boletins...
Informe-epidemiológico-1-COVID19-02-MAR-17-h.pdf já baixado.
Informe-epidemiológico-2-COVID19-03-MAR.pdf já baixado.
....
Feito.
Baixando PDFs dos leitos...
LEITOS-20-DE-ABRIL-09H.pdf.pdf já baixado.
LEITOS-20-DE-ABRIL-13H.pdf já baixado.
LEITOS-21-DE-ABRIL-10H.pdf.pdf.pdf já baixado.
...
Feito.
```

### ./cnes/load_cnes.sh

Este script faz o download da base de dados do CNES (Cadastro Nacional de Estabelecimentos de Saúde) e importa algumas tabelas relevantes para um banco de dados sqlite.