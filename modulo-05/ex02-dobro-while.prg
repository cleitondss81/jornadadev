FUNCTION Main()

   LOCAL cEntrada := ""
   LOCAL nValor   := 0

   QOut( "Digite um valor inteiro. Zero ou negativo encerra." )

   DO WHILE .T.

      ACCEPT "Valor: " TO cEntrada
      nValor := Val( cEntrada )

      IF nValor <= 0
         EXIT
      ENDIF

      QOut( "Dobro: " + AllTrim( Str( nValor * 2 ) ) )

   ENDDO

   QOut( "Programa encerrado." )

RETURN NIL
