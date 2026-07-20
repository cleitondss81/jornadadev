FUNCTION Main()

   LOCAL nSecreto  := 0
   LOCAL nPalpite  := 0
   LOCAL nI        := 0
   LOCAL cEntrada  := ""
   LOCAL lAcertou  := .F.

   nSecreto := HB_RandomInt( 1, 100 )

   QOut( "Adivinhe o numero entre 1 e 100. Voce tem 7 tentativas." )

   FOR nI := 1 TO 7

      ACCEPT "Tentativa " + AllTrim( Str( nI ) ) + " - Palpite: " TO cEntrada
      nPalpite := Val( cEntrada )

      IF nPalpite == nSecreto
         lAcertou := .T.
         EXIT
      ENDIF

      IF nPalpite < nSecreto
         QOut( "O numero secreto e MAIOR." )
      ELSE
         QOut( "O numero secreto e MENOR." )
      ENDIF

   NEXT

   QOut( "" )

   IF lAcertou
      QOut( "Parabens! Voce acertou em " + AllTrim( Str( nI ) ) + " tentativa(s)." )
   ELSE
      QOut( "Suas tentativas acabaram." )
   ENDIF

   QOut( "O numero secreto era: " + AllTrim( Str( nSecreto ) ) )

RETURN NIL
