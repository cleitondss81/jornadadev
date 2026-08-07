#include "protheus.ch"
#include "rwmake.ch"

/*/{Protheus.doc} STTZZLIB
====================================================================
    TCC - Harbour/ADVPL - Do Zero ao Protheus
    Controle de Nao Conformidades de Fornecedores (ISO 9001)
--------------------------------------------------------------------
    STTZZLIB.PRW - Biblioteca de funcoes comuns
--------------------------------------------------------------------
    Objetivo desta biblioteca:
      Centralizar as funcoes que sao usadas por mais de uma rotina
      (STTZZ1 e STTZZ2). Assim evitamos copiar/colar codigo e
      atendemos ao criterio de "reaproveitamento de codigo - zero
      duplicacao".

    Funcoes publicas (todas com prefixo U_ quando chamadas de fora):
      U_NomeFor(cFornec, cLoja)  -> nome do fornecedor (SA2)
      U_NomePro(cCodPro)         -> descricao do produto (SB1)
      U_PercNC(nOk, nNok)        -> percentual de nao conformidade
      U_CertVen(dValCer)         -> .T. se o certificado vence em 30 dias
      U_LogTCC(cFuncao, oErro)   -> grava log tecnico de erro
====================================================================
    Autor.....: Cleiton
    Modulo....: SIGACOM (Compras)
    Data......: 08/2026
/*/

// ------------------------------------------------------------------
// Constante usada no calculo de "certificado vencendo"
// (quantos dias antes do vencimento ja consideramos "alerta")
// ------------------------------------------------------------------
#define DIAS_ALERTA 30

/*/{Protheus.doc} NomeFor
Retorna o nome do fornecedor a partir da SA2.
Usa POSICIONE, que e a forma padrao e mais simples de "ler um
campo de outra tabela" sem abrir a tabela manualmente.

@param cFornec, caractere, codigo do fornecedor (A2_COD)
@param cLoja,   caractere, loja do fornecedor  (A2_LOJA)
@return caractere, nome do fornecedor (A2_NOME) ou "" se nao achar
/*/
User Function NomeFor(cFornec, cLoja)
    Local cNome := ""

    // Se veio codigo e loja, procura na SA2
    If !Empty(cFornec) .And. !Empty(cLoja)
        cNome := POSICIONE("SA2", 1, xFilial("SA2") + cFornec + cLoja, "A2_NOME")
    EndIf

Return cNome

/*/{Protheus.doc} NomePro
Retorna a descricao do produto a partir da SB1.

@param cCodPro, caractere, codigo do produto (B1_COD)
@return caractere, descricao do produto (B1_DESC) ou "" se nao achar
/*/
User Function NomePro(cCodPro)
    Local cDesc := ""

    If !Empty(cCodPro)
        cDesc := POSICIONE("SB1", 1, xFilial("SB1") + cCodPro, "B1_DESC")
    EndIf

Return cDesc

/*/{Protheus.doc} PercNC
Calcula o percentual de nao conformidade.
Formula: (NaoConforme / (Conforme + NaoConforme)) * 100

Cuidado importante (excecao): se as duas quantidades forem zero,
nao podemos dividir por zero. Nesse caso retornamos 0.

@param nOk,  numerico, quantidade conforme
@param nNok, numerico, quantidade nao conforme
@return numerico, percentual de nao conformidade (0 a 100)
/*/
User Function PercNC(nOk, nNok)
    Local nPerc := 0
    Local nTotal := 0

    Default nOk  := 0
    Default nNok := 0

    nTotal := nOk + nNok

    // Protecao contra divisao por zero
    If nTotal > 0
        nPerc := (nNok / nTotal) * 100
    EndIf

Return nPerc

/*/{Protheus.doc} CertVen
Informa se o certificado esta "vencendo", ou seja, se vence
dentro dos proximos 30 dias (a partir da data base do sistema).

@param dValCer, data, data de validade do certificado
@return logico, .T. se vence em ate 30 dias
/*/
User Function CertVen(dValCer)
    Local lVencendo := .F.

    If ValType(dValCer) == "D" .And. !Empty(dValCer)
        // Vence hoje ou dentro dos proximos 30 dias
        lVencendo := (dValCer <= dDataBase + DIAS_ALERTA)
    EndIf

Return lVencendo

/*/{Protheus.doc} LogTCC
Grava um log tecnico de erro em arquivo texto.
E chamada dentro dos BEGIN SEQUENCE das rotinas quando algo
da errado, para registrar o problema sem quebrar o sistema.

O arquivo fica na pasta \system\ do RootPath com o nome
"logtcc.log" e vai acumulando as ocorrencias (append).

@param cFuncao, caractere, nome da funcao onde ocorreu o erro
@param oErro,   objeto,    objeto de erro do BEGIN SEQUENCE (opcional)
@return logico, .T. se conseguiu gravar
/*/
User Function LogTCC(cFuncao, oErro)
    Local lOk      := .F.
    Local cArquivo := "\system\logtcc.log"
    Local cTexto   := ""
    Local cDescErr := ""
    Local nHandle  := 0

    Default cFuncao := "?"

    // Monta a descricao do erro, se veio o objeto de erro
    If ValType(oErro) == "O"
        cDescErr := oErro:Description
    Else
        cDescErr := "Sem detalhes do erro."
    EndIf

    // Monta a linha do log
    cTexto := DToC(dDataBase) + " " + Time() + " | "
    cTexto += "Funcao: " + cFuncao + " | "
    cTexto += "Erro: " + cDescErr + Chr(13) + Chr(10)

    // Abre o arquivo (cria se nao existir) e grava no final
    If File(cArquivo)
        nHandle := FOpen(cArquivo, 1)  // 1 = leitura/escrita
    Else
        nHandle := FCreate(cArquivo)
    EndIf

    If nHandle != -1
        FSeek(nHandle, 0, 2)           // vai para o fim do arquivo (append)
        FWrite(nHandle, cTexto)
        FClose(nHandle)
        lOk := .T.
    EndIf

Return lOk

/*/{Protheus.doc} ZZVal
Valida uma condicao e, se ela for falsa, mostra uma mensagem
amigavel ao usuario. Retorna a propria condicao, para ser usada
direto no X3_VALID (Val Usuario) dos campos.

Assim padronizamos todas as validacoes num unico lugar, em vez de
repetir IF/mensagem em cada campo (reaproveitamento de codigo).

Exemplo de uso no dicionario (X3_VALID):
   U_ZZVal(M->ZZ1_TOLERA >= 0 .And. M->ZZ1_TOLERA <= 100, ;
           "Tolerancia deve ser de 0 a 100!")

@param lOk,  logico,    resultado da validacao (.T. = ok)
@param cMsg, caractere, mensagem a exibir quando falhar
@return logico, o proprio lOk
/*/
User Function ZZVal(lOk, cMsg)

    Default lOk  := .F.
    Default cMsg := "Valor invalido!"

    If !lOk
        MsgAlert(cMsg, "Atencao")
    EndIf

Return lOk

// ==================================================================
// Funcoes de VALIDACAO com mensagem
// ------------------------------------------------------------------
// O campo X3_VLDUSER do dicionario aceita no maximo 128 caracteres.
// Como a validacao com POSICIONE + mensagem passa desse limite,
// colocamos a logica aqui e no dicionario chamamos so U_VldXXX().
// Elas leem os campos em edicao via M-> (variaveis do EnchoiceBar).
// ==================================================================

/*/{Protheus.doc} VldFor
Valida se o par fornecedor+loja (ZZ1_FORNEC/ZZ1_LOJAFO) existe na SA2.
Usada no X3_VLDUSER do campo ZZ1_LOJAFO.
@return logico, .T. se existir; senao mostra mensagem e retorna .F.
/*/
User Function VldFor()
    Local lOk := !Empty(POSICIONE("SA2", 1, xFilial("SA2") + M->ZZ1_FORNEC + M->ZZ1_LOJAFO, "A2_COD"))
    If !lOk
        MsgAlert("Fornecedor nao cadastrado na SA2!", "Atencao")
    EndIf
Return lOk

/*/{Protheus.doc} VldCer
Valida se o certificado (ZZ2_CONFOR) existe na ZZ1.
Usada no X3_VLDUSER do campo ZZ2_CONFOR.
@return logico, .T. se existir; senao mostra mensagem e retorna .F.
/*/
User Function VldCer()
    Local lOk := !Empty(POSICIONE("ZZ1", 1, xFilial("ZZ1") + M->ZZ2_CONFOR, "ZZ1_CODIGO"))
    If !lOk
        MsgAlert("Certificado nao cadastrado na ZZ1!", "Atencao")
    EndIf
Return lOk

/*/{Protheus.doc} VldPro
Valida se o produto (ZZ2_CODPRO) existe na SB1.
Usada no X3_VLDUSER do campo ZZ2_CODPRO.
@return logico, .T. se existir; senao mostra mensagem e retorna .F.
/*/
User Function VldPro()
    Local lOk := !Empty(POSICIONE("SB1", 1, xFilial("SB1") + M->ZZ2_CODPRO, "B1_COD"))
    If !lOk
        MsgAlert("Produto nao cadastrado na SB1!", "Atencao")
    EndIf
Return lOk