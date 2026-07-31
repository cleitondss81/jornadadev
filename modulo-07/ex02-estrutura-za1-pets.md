

a. Campos da ZA1

Ordem	Campo	Título	Tipo	Tamanho
1	ZA1_FILIAL	FILIAL	Caractere (C)	2
2	ZA1_NOME	NOME	Caractere (C)	40
3	ZA1_RACA	RACA	Caractere (C)	20
4	ZA1_DATA	DATANASC	Data (D)	8

![tabela_ZA1](tabela_ZA1.png)

O ZA1_FILIAL é o campo de filial, obrigatório em toda tabela. Depois vêm nome e raça (texto) e a data de nascimento (tipo data). Os tamanhos de NOME e RACA podem variar conforme o que foi definido na aula — o tipo é o que importa: texto para nome/raça e data para o nascimento.



b. Índice da ZA1

Foi criado um índice com a chave ZA1_FILIAL. Ele organiza os registros por filial.
Pensando na lista telefônica: o índice serve para o sistema achar os pets de forma organizada, sem procurar um por um na tabela toda. Só com a filial, porém, os pets ficam agrupados por filial mas sem ordem de busca por dentro.
Por isso seria melhor incluir o nome no índice (ZA1_FILIAL + ZA1_NOME). Assim os pets ficariam em ordem alfabética pelo nome — do mesmo jeito que você procura uma pessoa na lista telefônica pelo nome.


c. Por que o prefixo é Z

No Protheus, as tabelas que começam com Z são reservadas para o cliente — ou seja, tabelas customizadas, criadas por quem implementa, e não da TOTVS. As tabelas padrão usam outras letras (SB1, SF2, SE1...). Usar o Z garante que a ZA1 não vai colidir com nenhuma tabela da TOTVS nem ser sobrescrita quando o sistema for atualizado.


d. Por que os campos começam com ZA1_

No Protheus todo campo carrega o prefixo da tabela a que pertence. Como a tabela é ZA1, os campos dela começam com ZA1_ (ZA1_NOME, ZA1_RACA, ZA1_DATA...). Isso deixa claro de qual tabela o campo é e evita confusão — várias tabelas podem ter um campo "NOME" ou "DATA", e o prefixo indica que aquele campo pertence à tabela dos pets.









