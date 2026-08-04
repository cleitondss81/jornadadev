#INCLUDE "protheus.ch"

// Incluir com valida  o (chamado pelo browse)
User Function STINC(cAlias, nReg, nOpc)
Return AxInclui(cAlias, nReg, nOpc, , , , "U_STTUDOK()")


// Alterar com valida  o (chamado pelo browse)
User Function STALT(cAlias, nReg, nOpc)
Return AxAltera(cAlias, nReg, nOpc, , , , "U_STTUDOK()")


// Valida  o dos campos obrigat rios (roda ao confirmar)
User Function STTUDOK()

    Local lRet := .T.

    If Empty(M->Z1_CLIENTE)
        MsgAlert("Informe o Cliente.", "Atenção")
        lRet := .F.
    ElseIf Empty(M->Z1_ASSUNTO)
        MsgAlert("Informe o Assunto.", "Atenção")
        lRet := .F.
    EndIf

Return lRet


// Grava  o blindada com transa  o (Exerc cio 6)
User Function STSALVAR(cCodigo, cCliente, cNome, cAssunto)

    Local lRet  := .T.
    Local oErro := Nil

    ErrorBlock({|e| Break(e)})
    BeginTran()

    Begin Sequence

        If Empty(cCliente) .Or. Empty(cAssunto)
            MsgAlert("Cliente e Assunto s o obrigat rios.", "Atenção")
            Break(.T.)
        EndIf

        RecLock("SZ1", .T.)
            SZ1->Z1_FILIAL  := xFilial("SZ1")
            SZ1->Z1_CODIGO  := cCodigo
            SZ1->Z1_CLIENTE := cCliente
            SZ1->Z1_NOME    := cNome
            SZ1->Z1_ASSUNTO := cAssunto
            SZ1->Z1_DATA    := dDataBase
            SZ1->Z1_HORA    := Time()
        MsUnLock()

        CommitTran()

    Recover Using oErro

        RollBackTran()
        MsgStop("Não foi possível salvar. Nada foi gravado.", "Erro")
        U_GRAVARLOG("STSALVAR", oErro)
        lRet := .F.

    End Sequence

Return lRet


// Grava o erro no console e em arquivo de log
User Function GRAVARLOG(cFuncao, oErro)

    Local cDesc  := "Falha de validação."
    Local cLinha := ""

    If ValType(oErro) == "O"
        cDesc := AllTrim(oErro:Description)
    EndIf

    cLinha := DtoC(dDataBase) + " " + Time() + " - " + cFuncao + " - " + cDesc

    ConOut(cLinha)
    MemoWrite("\log\STTIP.log", cLinha)

Return

/*

Print - ![ALERTA-ERRO](ALERTA-ERRO.png)

*/

