PRINT CADASTRO CLIENTE - INCLUINDO AUTOMATICO.

![CEP-SOROCABA](CEP-SOROCABA.png)

GATILHOS - A1_CEP

![A1_CEP](A1_CEP.png)


A1_CEP - SEQ-001

![A1_CEP-SEQ001](A1_CEP-SEQ001.png)

A1_CEP - SEQ-002

![A1_CEP-SEQ002](A1_CEP-SEQ002.png)

A1_CEP - SEQ-003

![A1_CEP-SEQ003](A1_CEP-SEQ003.png)


---------------------------------------------------------------------

#include "protheus.ch"

/*/{Protheus.doc} STCEP
Preenchimento automÃ¡tico de endereÃ§o a partir do CEP.

Feita para ser chamada por um GATILHO (SX7) do campo A1_CEP no cadastro de
Clientes (SA1). O gatilho pergunta "qual Ã© o bairro/municÃ­pio/UF desse CEP?"
e esta funÃ§Ã£o responde.

Uso na regra do gatilho (SIGACFG â†’ DicionÃ¡rio â†’ Gatilhos):
    U_STCEP(M->A1_CEP,"BAIRRO")
    U_STCEP(M->A1_CEP,"CIDADE")
    U_STCEP(M->A1_CEP,"UF")

@param cCEP     CEP digitado (aceita com ou sem mÃ¡scara: 18035000 ou 18035-000)
@param cRetorno O que devolver: "BAIRRO" (padrÃ£o), "CIDADE" ou "UF"
@return caractere com o valor encontrado, ou "" se o CEP nÃ£o estiver na tabela

@author  Jornada DEV START â€” MÃ³dulo 8
@since   28/07/2026
/*/
USER FUNCTION STCEP(cCEP, cRetorno)

    Local aTabela  := aTabCEP()
    Local cLimpo   := ""
    Local cRet     := ""
    Local nPos     := 0

    Default cCEP     := ""
    Default cRetorno := "BAIRRO"

    // 1) Limpa a mÃ¡scara: "18035-000" vira "18035000"
    cLimpo := StrTran(StrTran(AllTrim(cCEP), "-", ""), ".", "")

    // 2) Procura o CEP na tabela (aScan devolve a posiÃ§Ã£o ou 0)
    nPos := aScan(aTabela, {|aLinha| aLinha[1] == cLimpo })

    // 3) Devolve o pedaÃ§o do endereÃ§o que o gatilho pediu
    If nPos > 0
        Do Case
            Case Upper(AllTrim(cRetorno)) == "BAIRRO"
                cRet := aTabela[nPos][2]
            Case Upper(AllTrim(cRetorno)) == "CIDADE"
                cRet := aTabela[nPos][3]
            Case Upper(AllTrim(cRetorno)) == "UF"
                cRet := aTabela[nPos][4]
        EndCase
    EndIf

RETURN cRet


/*/{Protheus.doc} STCEPTESTE
Teste rÃ¡pido SEM precisar do cadastro de clientes.
Execute pelo SmartClient (MiscelÃ¢nea â†’ ExecuÃ§Ã£o â†’ Programa) digitando STCEPTESTE.
Serve para provar que a funÃ§Ã£o responde ANTES de amarrar o gatilho.

NÃ£o usa caixa de digitaÃ§Ã£o de propÃ³sito: assim funciona em qualquer versÃ£o,
sem depender de funÃ§Ã£o de tela. Para testar outro CEP, troque a linha do cCEP
e compile de novo (F9).
/*/
USER FUNCTION STCEPTESTE()

    Local cCEP := "18035-000"   // <-- troque aqui para testar outro CEP

    MsgInfo("CEP informado: " + cCEP                       + CRLF + ;
            "Bairro: "        + U_STCEP(cCEP, "BAIRRO")    + CRLF + ;
            "Cidade: "        + U_STCEP(cCEP, "CIDADE")    + CRLF + ;
            "UF: "            + U_STCEP(cCEP, "UF"), "Consulta de CEP")

RETURN NIL


/*/{Protheus.doc} aTabCEP
Tabela de CEPs usada no exercÃ­cio.

âš ï¸� ATENÃ‡ÃƒO â€” dados de EXEMPLO, montados para a aula.
Em um sistema de verdade estes dados viriam de:
  a) uma tabela de CEP dentro do prÃ³prio Protheus, consultada com Posicione(); ou
  b) um serviÃ§o externo (ex.: ViaCEP) chamado por HTTP.
O que interessa aqui Ã© o MECANISMO do gatilho, nÃ£o a base de CEP.

Estrutura de cada linha: { CEP, BAIRRO, CIDADE, UF }
/*/
STATIC FUNCTION aTabCEP()
RETURN {                                                          ;
    { "18035000", "Centro",          "Sorocaba",       "SP" },    ;
    { "18040000", "Vila Hortencia",  "Sorocaba",       "SP" },    ;
    { "18045000", "Jardim Paulista", "Sorocaba",       "SP" },    ;
    { "18110000", "Centro",          "Votorantim",     "SP" },    ;
    { "18200000", "Centro",          "Itapetininga",   "SP" },    ;
    { "01310100", "Bela Vista",      "Sao Paulo",      "SP" },    ;
    { "01001000", "Se",              "Sao Paulo",      "SP" },    ;
    { "04547000", "Vila Olimpia",    "Sao Paulo",      "SP" },    ;
    { "08010000", "Itaquera",        "Sao Paulo",      "SP" },    ;
    { "09010000", "Centro",          "Santo Andre",    "SP" },    ;
    { "13010000", "Centro",          "Campinas",       "SP" },    ;
    { "13330000", "Centro",          "Indaiatuba",     "SP" },    ;
    { "14010000", "Centro",          "Ribeirao Preto", "SP" },    ;
    { "06010000", "Centro",          "Osasco",         "SP" },    ;
    { "07010000", "Centro",          "Guarulhos",      "SP" },    ;
    { "11010000", "Centro",          "Santos",         "SP" },    ;
    { "12210000", "Centro",          "Sao Jose Campos","SP" },    ;
    { "37540000", "Centro",          "Santa Rita",     "MG" },    ;
    { "70070000", "Asa Sul",         "Brasilia",       "DF" },    ;
    { "20010000", "Centro",          "Rio de Janeiro", "RJ" }     ;
}