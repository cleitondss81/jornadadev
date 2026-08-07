#include "protheus.ch"
#include "rwmake.ch"

/*/{Protheus.doc} STTZZCLS
====================================================================
    TCC - Harbour/ADVPL - Do Zero ao Protheus
    Controle de Nao Conformidades de Fornecedores (ISO 9001)
--------------------------------------------------------------------
    STTZZCLS.PRW - Classe ADVPL (POO) - DIFERENCIAL
--------------------------------------------------------------------
    Este arquivo atende ao diferencial:
      "Implementar pelo menos uma classe ADVPL (POO) no projeto".

    A classe ZCertificado representa o CERTIFICADO de qualidade de
    um fornecedor. Em vez de espalhar as regras de vencimento e de
    tolerancia pelas rotinas, juntamos tudo aqui, num unico lugar.
    Isso deixa o codigo mais organizado e facil de reaproveitar.

    Como usar (exemplo):
      Local oCert := ZCertificado():New(dValCer, nTolera)
      If oCert:Vencido()
          MsgAlert("Certificado vencido!")
      EndIf
      cCor := oCert:StatusCor()   // "VERMELHO", "AMARELO" ou "VERDE"
====================================================================
    Autor.....: Cleiton
    Data......: 08/2026
/*/

// Quantos dias antes do vencimento consideramos "alerta"
#define DIAS_ALERTA 30

// ------------------------------------------------------------------
// Definicao da classe
// ------------------------------------------------------------------
CLASS ZCertificado

    // Atributos (os "dados" que o objeto guarda)
    // Obs.: no ADVPL classico (Protheus 8) nao se usa tipagem "AS Tipo".
    DATA dValidade    // data de validade do certificado
    DATA nTolerancia  // tolerancia (%) permitida de nao conformidade

    // Metodos (as "acoes" que o objeto sabe fazer)
    METHOD New(dValidade, nTolerancia) CONSTRUCTOR
    METHOD DiasParaVencer()
    METHOD Vencido()
    METHOD Vencendo()
    METHOD StatusCor()
    METHOD DentroTolerancia(nPercNC)

ENDCLASS

/*/{Protheus.doc} ZCertificado::New
Construtor da classe. E chamado quando fazemos ZCertificado():New(...)
Guarda a data de validade e a tolerancia dentro do objeto.

@param dValidade,   data,     data de validade do certificado
@param nTolerancia, numerico, tolerancia (%) do fornecedor
@return objeto, a instancia criada (Self)
/*/
METHOD New(dValidade, nTolerancia) CLASS ZCertificado

    Default dValidade   := CToD("")
    Default nTolerancia := 0

    ::dValidade   := dValidade
    ::nTolerancia := nTolerancia

Return Self

/*/{Protheus.doc} ZCertificado::DiasParaVencer
Quantos dias faltam para o certificado vencer.
Numero negativo = ja venceu ha X dias.

@return numerico, dias ate o vencimento
/*/
METHOD DiasParaVencer() CLASS ZCertificado
    Local nDias := 0

    If !Empty(::dValidade)
        nDias := ::dValidade - dDataBase
    EndIf

Return nDias

/*/{Protheus.doc} ZCertificado::Vencido
Diz se o certificado JA venceu (validade anterior a hoje).

@return logico, .T. se vencido
/*/
METHOD Vencido() CLASS ZCertificado
Return (!Empty(::dValidade) .And. ::dValidade < dDataBase)

/*/{Protheus.doc} ZCertificado::Vencendo
Diz se o certificado esta perto de vencer (dentro de 30 dias),
mas ainda nao venceu.

@return logico, .T. se vence nos proximos 30 dias
/*/
METHOD Vencendo() CLASS ZCertificado
    Local lVencendo := .F.

    If !Empty(::dValidade)
        lVencendo := (::dValidade >= dDataBase) ;
                 .And. (::dValidade <= dDataBase + DIAS_ALERTA)
    EndIf

Return lVencendo

/*/{Protheus.doc} ZCertificado::StatusCor
Devolve a cor que representa a situacao do certificado.
Usada para montar a legenda colorida do browse:
   VERMELHO -> vencido
   AMARELO  -> vence em 30 dias
   VERDE    -> ok

@return caractere, "VERMELHO", "AMARELO" ou "VERDE"
/*/
METHOD StatusCor() CLASS ZCertificado
    Local cCor := "VERDE"

    If ::Vencido()
        cCor := "VERMELHO"
    ElseIf ::Vencendo()
        cCor := "AMARELO"
    EndIf

Return cCor

/*/{Protheus.doc} ZCertificado::DentroTolerancia
Verifica se um percentual de nao conformidade esta DENTRO da
tolerancia aceita pelo certificado do fornecedor.

@param nPercNC, numerico, percentual de nao conformidade apurado
@return logico, .T. se esta dentro da tolerancia (ok)
/*/
METHOD DentroTolerancia(nPercNC) CLASS ZCertificado
    Default nPercNC := 0
Return (nPercNC <= ::nTolerancia)