FUNCTION Main()

   LOCAL nNum1
   LOCAL nNum2
   LOCAL cOperacao
   LOCAL nResultado := 0

   CLS
   ? "=== CALCULADORA ==="
   ?

   nNum1     := LerNumero( "Digite o primeiro numero: " )
   nNum2     := LerNumero( "Digite o segundo numero: " )
   cOperacao := LerOperacao()

   IF Calcular( nNum1, nNum2, cOperacao, @nResultado )
      MostrarResultado( nNum1, nNum2, cOperacao, nResultado )
   ELSE
      ?
      ? "Nao foi possivel calcular (divisao por zero ou operacao invalida)."
   ENDIF

   ?
   ? "Pressione uma tecla para sair..."
   Inkey( 0 )

   RETURN NIL


// Le um numero digitado pelo usuario
FUNCTION LerNumero( cMensagem )

   LOCAL cTexto := Space( 15 )

   ACCEPT cMensagem TO cTexto

   RETURN Val( cTexto )


// Le a operacao desejada
FUNCTION LerOperacao()

   LOCAL cTexto := Space( 1 )

   ACCEPT "Digite a operacao ( + - * / ): " TO cTexto

   RETURN AllTrim( cTexto )


// Faz o calculo. Devolve .T. se deu certo e .F. se nao deu.
FUNCTION Calcular( nNum1, nNum2, cOperacao, nResultado )

   LOCAL lOk := .T.

   DO CASE
   CASE cOperacao == "+"
      nResultado := nNum1 + nNum2

   CASE cOperacao == "-"
      nResultado := nNum1 - nNum2

   CASE cOperacao == "*"
      nResultado := nNum1 * nNum2

   CASE cOperacao == "/"
      IF nNum2 == 0
         lOk := .F.                 // divisao por zero
      ELSE
         nResultado := nNum1 / nNum2
      ENDIF

   OTHERWISE
      lOk := .F.                    // operacao invalida
   ENDCASE

   RETURN lOk


// Mostra o resultado na tela
FUNCTION MostrarResultado( nNum1, nNum2, cOperacao, nResultado )

   ?
   ? "Resultado: " + AllTrim( Str( nNum1, 15, 2 ) ) + " " + ;
                     cOperacao + " " + ;
                     AllTrim( Str( nNum2, 15, 2 ) ) + " = " + ;
                     AllTrim( Str( nResultado, 15, 2 ) )

   RETURN NIL
