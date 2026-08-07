#include "protheus.ch"
#include "rwmake.ch"

/*/{Protheus.doc} STTZZTST
====================================================================
    TCC - Harbour/ADVPL - Do Zero ao Protheus
--------------------------------------------------------------------
    STTZZTST.PRW - Gerador de MASSA DE DADOS de teste
--------------------------------------------------------------------
    Cria alguns registros de exemplo para conseguir testar as
    rotinas sem precisar digitar tudo na mao:
      - 2 fornecedores (SA2)
      - 2 produtos (SB1)
      - 3 certificados (ZZ1) - um vencido, um vencendo, um ok
      - 3 ocorrencias (ZZ2) - uma acima da tolerancia

    Como rodar: no SmartClient, "Outras Acoes / U_STTZZTST" ou
    coloque no menu temporariamente. Rode UMA vez.

    Atencao: e um utilitario de teste; nao entra no menu final.
====================================================================
    Autor.....: Cleiton
    Data......: 08/2026
/*/
User Function STTZZTST()
    Local oErro   := Nil
    Local bErrAnt := ErrorBlock({|e| oErro := e, Break(e)})

    BEGIN SEQUENCE

        // ----------------------------- FORNECEDORES (SA2)
        GravaSA2("000001", "01", "FORNECEDOR ALFA LTDA")
        GravaSA2("000002", "01", "FORNECEDOR BETA SA")

        // ----------------------------- PRODUTOS (SB1)
        GravaSB1("PROD001", "PARAFUSO SEXTAVADO M8", "PC")
        GravaSB1("PROD002", "CHAPA DE ACO 2MM"     , "KG")

        // ----------------------------- CERTIFICADOS (ZZ1)
        // C0001 -> vencido (data no passado)
        GravaZZ1("C00001", "000001", "01", "ISO 9001 - Alfa", dDataBase - 10, 5)
        // C0002 -> vence em 15 dias (amarelo)
        GravaZZ1("C00002", "000002", "01", "ISO 9001 - Beta", dDataBase + 15, 10)
        // C0003 -> ok (vence daqui a 1 ano)
        GravaZZ1("C00003", "000001", "01", "ISO 9001 - Alfa 2", dDataBase + 365, 3)

        // ----------------------------- OCORRENCIAS (ZZ2)
        // Dentro da tolerancia (verde): 2 nao conf de 100 = 2% (tolera 5)
        GravaZZ2("C00001", "000001", "01", "PROD001", dDataBase - 5, 98, 2, 10.00)
        // Acima da tolerancia (vermelho): 20 de 100 = 20% (tolera 5)
        GravaZZ2("C00001", "000001", "01", "PROD001", dDataBase - 3, 80, 20, 10.00)
        // Beta ok: 5 de 100 = 5% (tolera 10)
        GravaZZ2("C00002", "000002", "01", "PROD002", dDataBase - 1, 95, 5, 25.00)

        MsgAlert("Massa de dados de teste criada com sucesso!", "OK")

    RECOVER USING oErro

        MsgAlert("Erro ao criar a massa de dados: " + oErro:Description, "Erro")
        U_LogTCC("STTZZTST", oErro)

    END SEQUENCE

    ErrorBlock(bErrAnt)

Return Nil

// ------------------------------------------------------------------
// Funcoes internas (Static) - so existem dentro deste arquivo.
// Cada uma grava um registro so se ele ainda nao existir.
// ------------------------------------------------------------------

Static Function GravaSA2(cCod, cLoja, cNome)
    dbSelectArea("SA2")
    SA2->(dbSetOrder(1))
    If !SA2->(dbSeek(xFilial("SA2") + cCod + cLoja))
        RecLock("SA2", .T.)
            SA2->A2_FILIAL := xFilial("SA2")
            SA2->A2_COD    := cCod
            SA2->A2_LOJA   := cLoja
            SA2->A2_NOME   := cNome
            SA2->A2_NREDUZ := SubStr(cNome, 1, 20)
        MsUnLock()
    EndIf
Return Nil

Static Function GravaSB1(cCod, cDesc, cUM)
    dbSelectArea("SB1")
    SB1->(dbSetOrder(1))
    If !SB1->(dbSeek(xFilial("SB1") + cCod))
        RecLock("SB1", .T.)
            SB1->B1_FILIAL := xFilial("SB1")
            SB1->B1_COD    := cCod
            SB1->B1_DESC   := cDesc
            SB1->B1_UM     := cUM
            SB1->B1_TIPO   := "MP"
            SB1->B1_LOCPAD := "01"
        MsUnLock()
    EndIf
Return Nil

Static Function GravaZZ1(cCod, cForn, cLoja, cCertif, dVal, nTol)
    dbSelectArea("ZZ1")
    ZZ1->(dbSetOrder(1))
    If !ZZ1->(dbSeek(xFilial("ZZ1") + cCod))
        RecLock("ZZ1", .T.)
            ZZ1->ZZ1_FILIAL := xFilial("ZZ1")
            ZZ1->ZZ1_CODIGO := cCod
            ZZ1->ZZ1_FORNEC := cForn
            ZZ1->ZZ1_LOJAFO := cLoja
            ZZ1->ZZ1_CERTIF := cCertif
            ZZ1->ZZ1_VALCER := dVal
            ZZ1->ZZ1_TOLERA := nTol
            ZZ1->ZZ1_TOTOK  := 0
            ZZ1->ZZ1_TOTNOK := 0
        MsUnLock()
    EndIf
Return Nil

Static Function GravaZZ2(cConfor, cForn, cLoja, cProd, dData, nOk, nNok, nVlr)
    dbSelectArea("ZZ2")
    ZZ2->(dbSetOrder(1))
    // chave: FILIAL + CONFOR + DATA + HORA (usamos hora fixa p/ teste)
    If !ZZ2->(dbSeek(xFilial("ZZ2") + cConfor + DToS(dData) + "12:00"))
        RecLock("ZZ2", .T.)
            ZZ2->ZZ2_FILIAL := xFilial("ZZ2")
            ZZ2->ZZ2_CONFOR := cConfor
            ZZ2->ZZ2_FORNEC := cForn
            ZZ2->ZZ2_LOJAFO := cLoja
            ZZ2->ZZ2_CODPRO := cProd
            ZZ2->ZZ2_DATA   := dData
            ZZ2->ZZ2_HORA   := "12:00"
            ZZ2->ZZ2_QTDOK  := nOk
            ZZ2->ZZ2_QTDNOK := nNok
            ZZ2->ZZ2_VLRUNI := nVlr
        MsUnLock()
    EndIf
Return Nil