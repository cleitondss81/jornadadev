FUNCTION Main()

   LOCAL cEntrada := ""
   LOCAL nValor   := 0
   LOCAL nTotal   := 0
   LOCAL nQtd     := 0

   QOut( "Digite os valores. O zero encerra." )

   DO WHILE .T.

      ACCEPT "Valor: " TO cEntrada
      nValor := Val( cEntrada )

      IF nValor == 0
         EXIT
      ENDIF

      nTotal := nTotal + nValor
      nQtd   := nQtd + 1

   ENDDO

   QOut( "Soma total: " + AllTrim( Str( nTotal ) ) )
   QOut( "Quantidade: " + AllTrim( Str( nQtd ) ) )

RETURN NIL
