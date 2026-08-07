#include "protheus.ch"
#include "rwmake.ch"

/*/{Protheus.doc} STTZZ1
====================================================================
    TCC - Harbour/ADVPL - Do Zero ao Protheus
    Controle de Nao Conformidades de Fornecedores (ISO 9001)
--------------------------------------------------------------------
    STTZZ1.PRW - Rotina mBrowse da tabela ZZ1
                 (Controle de Fornecimento / Certificados)
--------------------------------------------------------------------
    O que esta rotina faz:
      - Abre a tela (browse) com os certificados dos fornecedores.
      - Mostra uma LEGENDA colorida pela validade do certificado:
            Vermelho -> vencido
            Amarelo  -> vence em 30 dias
            Verde    -> ok
      - Tem os botoes padrao (Incluir, Alterar, Visualizar, Excluir).
      - Tem um botao extra "Ocorrencias" que abre a ZZ2 ja filtrada
        pelo certificado selecionado.
      - Bloqueia a exclusao de uma ZZ1 que tenha ocorrencias (ZZ2)
        vinculadas  (DIFERENCIAL: integridade referencial).

    Observacao para nivel junior:
      Usamos o mBrowse "classico" com aRotina (lista de opcoes do
      menu superior). E a forma mais simples de manter uma tabela.
====================================================================
    Autor.....: Cleiton
    Modulo....: SIGACOM (Compras)
    Data......: 08/2026
/*/
User Function STTZZ1()

    // No ADVPL classico, os Local vem SEMPRE antes de qualquer
    // codigo executavel (inclusive antes dos Private com atribuicao).
    Local aCores := {}

    // aRotina = opcoes do menu (Pesquisar, Incluir, etc.)
    // cCadastro = titulo que aparece na janela
    // Sao Private porque as funcoes AxInclui/AxAltera as enxergam.
    Private aRotina   := {}
    Private cCadastro := "Controle de Fornecimento (ISO 9001)"

    // ---------------------------------------------------------------
    // 1) Monta a legenda de cores (avaliada linha a linha).
    //    A primeira condicao verdadeira vence, por isso a ordem
    //    importa: primeiro vencido, depois vencendo, depois ok.
    // ---------------------------------------------------------------
    AAdd(aCores, {"ZZ1_VALCER <  dDataBase"     , "BR_VERMELHO"}) // vencido
    AAdd(aCores, {"ZZ1_VALCER <= dDataBase + 30", "BR_AMARELO" }) // vence em 30 dias
    AAdd(aCores, {".T."                         , "BR_VERDE"   }) // ok

    // ---------------------------------------------------------------
    // 2) Monta as opcoes do menu.
    //    Formato: {Titulo, Funcao, 0, Operacao}
    //    Operacao: 1=pesquisar 2=visualizar 3=incluir 4=alterar 5=excluir
    // ---------------------------------------------------------------
    AAdd(aRotina, {"Pesquisar" , "AxPesqui"    , 0, 1})
    AAdd(aRotina, {"Visualizar", "AxVisual"    , 0, 2})
    AAdd(aRotina, {"Incluir"   , "AxInclui"    , 0, 3})
    AAdd(aRotina, {"Alterar"   , "AxAltera"    , 0, 4})
    AAdd(aRotina, {"Excluir"   , "U_STZ1DEL"   , 0, 5}) // exclusao com bloqueio
    AAdd(aRotina, {"Ocorrencias","U_STZ1OC"    , 0, 6}) // abre ZZ2 filtrada

    // ---------------------------------------------------------------
    // 3) Posiciona a tabela e abre o browse.
    // ---------------------------------------------------------------
    dbSelectArea("ZZ1")
    ZZ1->(dbSetOrder(1))  // ordem 1 = FILIAL + CODIGO
    ZZ1->(dbGoTop())

    // aColors (legenda) e o 11o parametro do mBrowse -> 5 virgulas vazias
    mBrowse(6, 1, 22, 75, "ZZ1", , , , , , aCores)

Return Nil

/*/{Protheus.doc} STZ1DEL
Exclusao da ZZ1 COM regra de integridade.
Antes de excluir, verifica se existe alguma ocorrencia (ZZ2)
ligada a este certificado. Se existir, NAO deixa excluir.

Toda a gravacao esta protegida por BEGIN SEQUENCE, com mensagem
amigavel ao usuario e log tecnico em caso de erro.

@param cAlias, caractere, alias da tabela ("ZZ1")
@param nReg,   numerico,  numero do registro posicionado
@param nOpc,   numerico,  operacao (5 = excluir)
/*/
User Function STZ1DEL(cAlias, nReg, nOpc)
    Local lRet      := .T.
    Local oErro     := Nil
    Local cCodigo   := ZZ1->ZZ1_CODIGO
    Local bErrAnt   := ErrorBlock({|e| oErro := e, Break(e)})

    Default cAlias := "ZZ1"
    Default nOpc   := 5

    // -----------------------------------------------------------
    // 1) Regra de integridade: existe ZZ2 vinculada?
    //    A ZZ2 guarda o codigo do certificado em ZZ2_CONFOR.
    // -----------------------------------------------------------
    ZZ2->(dbSetOrder(1)) // FILIAL + CONFOR + DATA + HORA
    If ZZ2->(dbSeek(xFilial("ZZ2") + cCodigo))
        MsgAlert("Nao e possivel excluir: existem ocorrencias " + ;
                 "(ZZ2) vinculadas a este certificado.", "Atencao")
        ErrorBlock(bErrAnt)
        Return .F.
    EndIf

    // -----------------------------------------------------------
    // 2) Confirmacao do usuario.
    // -----------------------------------------------------------
    If !MsgYesNo("Confirma a exclusao do certificado " + ;
                 AllTrim(cCodigo) + "?", "Confirmacao")
        ErrorBlock(bErrAnt)
        Return .F.
    EndIf

    // -----------------------------------------------------------
    // 3) Exclusao protegida por BEGIN SEQUENCE.
    //    Se der erro na gravacao, mostramos mensagem amigavel e
    //    gravamos o log tecnico (compativel com Protheus 8).
    // -----------------------------------------------------------
    BEGIN SEQUENCE

        ZZ1->(dbSetOrder(1))
        If ZZ1->(dbSeek(xFilial("ZZ1") + cCodigo))
            RecLock("ZZ1", .F.)   // .F. = alterar registro existente
                ZZ1->(dbDelete()) // marca o registro como excluido
            MsUnLock()            // libera o registro (confirma a gravacao)
        EndIf

    RECOVER USING oErro

        lRet := .F.
        MsgAlert("Ocorreu um erro ao excluir o certificado. " + ;
                 "A operacao foi cancelada.", "Erro")
        U_LogTCC("STZ1DEL", oErro)  // grava o log tecnico

    END SEQUENCE

    // Restaura o tratamento de erro anterior
    ErrorBlock(bErrAnt)

Return lRet

/*/{Protheus.doc} STZ1OC
Botao "Ocorrencias": abre a rotina da ZZ2 ja filtrada apenas
pelas ocorrencias do certificado (ZZ1) que esta selecionado.

@param cAlias, caractere, alias ("ZZ1")
@param nReg,   numerico,  registro posicionado
@param nOpc,   numerico,  operacao
/*/
User Function STZ1OC(cAlias, nReg, nOpc)
    Local cCodigo := ZZ1->ZZ1_CODIGO

    // Chama a versao filtrada da rotina da ZZ2 (definida em STTZZ2.PRW)
    U_STTZ2F(cCodigo)

Return Nil