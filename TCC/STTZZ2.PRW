#include "protheus.ch"
#include "rwmake.ch"

/*/{Protheus.doc} STTZZ2
====================================================================
    TCC - Harbour/ADVPL - Do Zero ao Protheus
    Controle de Nao Conformidades de Fornecedores (ISO 9001)
--------------------------------------------------------------------
    STTZZ2.PRW - Rotina mBrowse da tabela ZZ2
                 (Ocorrencias de Fornecimento)
--------------------------------------------------------------------
    O que este arquivo tem:
      U_STTZZ2()  -> browse completo das ocorrencias.
      U_STTZ2F()  -> browse FILTRADO por um certificado (ZZ1),
                     chamado pelo botao "Ocorrencias" da STTZZ1.
      U_ZZ2NOK()  -> funcao auxiliar da legenda: diz se a ocorrencia
                     esta ACIMA da tolerancia do certificado.

    Legenda de cores:
      Vermelho -> % nao conforme acima da tolerancia do certificado
      Verde    -> dentro da tolerancia

    Formula do % nao conforme:
      % NC = (QtdNaoConforme / (QtdConforme + QtdNaoConforme)) * 100
====================================================================
    Autor.....: Cleiton
    Modulo....: SIGACOM (Compras)
    Data......: 08/2026
/*/
User Function STTZZ2()

    Local aCores := {}

    Private aRotina   := {}
    Private cCadastro := "Ocorrencias de Fornecimento"

    // Legenda: vermelho quando esta acima da tolerancia, senao verde.
    AAdd(aCores, {"U_ZZ2NOK()", "BR_VERMELHO"}) // acima da tolerancia
    AAdd(aCores, {".T."       , "BR_VERDE"   }) // dentro da tolerancia

    AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
    AAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
    AAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
    AAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
    AAdd(aRotina, {"Excluir"   , "AxDeleta", 0, 5})

    dbSelectArea("ZZ2")
    ZZ2->(dbSetOrder(1))  // FILIAL + CONFOR + DATA + HORA
    ZZ2->(dbGoTop())

    // aColors (legenda) e o 11o parametro do mBrowse -> 5 virgulas vazias
    mBrowse(6, 1, 22, 75, "ZZ2", , , , , , aCores)

Return Nil

/*/{Protheus.doc} STTZ2F
Versao FILTRADA do browse da ZZ2.
Exibe apenas as ocorrencias cujo ZZ2_CONFOR seja igual ao codigo
do certificado (ZZ1) recebido. E chamada pelo botao "Ocorrencias"
da rotina STTZZ1.

@param cCodZZ1, caractere, codigo do certificado (ZZ1_CODIGO)
/*/
User Function STTZ2F(cCodZZ1)

    Local aCores := {}

    Default cCodZZ1 := ""

    Private aRotina   := {}
    Private cCadastro := "Ocorrencias do Certificado " + AllTrim(cCodZZ1)

    AAdd(aCores, {"U_ZZ2NOK()", "BR_VERMELHO"})
    AAdd(aCores, {".T."       , "BR_VERDE"   })

    AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
    AAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
    AAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
    AAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
    AAdd(aRotina, {"Excluir"   , "AxDeleta", 0, 5})

    dbSelectArea("ZZ2")
    ZZ2->(dbSetOrder(1))

    // Aplica o filtro: so mostra as ocorrencias deste certificado.
    ZZ2->(dbSetFilter({|| ZZ2_CONFOR == cCodZZ1}, ;
                      "ZZ2_CONFOR == '" + cCodZZ1 + "'"))
    ZZ2->(dbGoTop())

    // aColors (legenda) e o 11o parametro do mBrowse -> 5 virgulas vazias
    mBrowse(6, 1, 22, 75, "ZZ2", , , , , , aCores)

    // Muito importante: limpa o filtro ao sair, senao ele
    // continuaria valendo nas proximas telas.
    ZZ2->(dbClearFilter())

Return Nil

/*/{Protheus.doc} ZZ2NOK
Funcao auxiliar da LEGENDA da ZZ2.
Retorna .T. quando a ocorrencia posicionada esta ACIMA da
tolerancia definida no certificado (ZZ1) correspondente.

Passos:
  1. Calcula o % de nao conformidade da ocorrencia atual.
  2. Busca a tolerancia (ZZ1_TOLERA) do certificado vinculado.
  3. Compara: se o % passou da tolerancia, retorna .T. (vermelho).

@return logico, .T. se acima da tolerancia
/*/
User Function ZZ2NOK()
    Local lAcima  := .F.
    Local nPercNC := 0
    Local nTolera := 0

    // 1) percentual de nao conformidade da ocorrencia atual
    //    (reaproveita a funcao da biblioteca STTZZLIB)
    nPercNC := U_PercNC(ZZ2->ZZ2_QTDOK, ZZ2->ZZ2_QTDNOK)

    // 2) tolerancia do certificado vinculado (ZZ2_CONFOR -> ZZ1_TOLERA)
    nTolera := POSICIONE("ZZ1", 1, ;
                         xFilial("ZZ1") + ZZ2->ZZ2_CONFOR, ;
                         "ZZ1_TOLERA")

    // 3) acima da tolerancia?
    lAcima := (nPercNC > nTolera)

Return lAcima