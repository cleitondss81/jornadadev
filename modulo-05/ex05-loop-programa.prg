FUNCTION Main()

   LOCAL cNome    := ""
   LOCAL cDisc    := ""
   LOCAL cEntrada := ""
   LOCAL cResp    := ""
   LOCAL nNota1   := 0
   LOCAL nNota2   := 0
   LOCAL nMedia   := 0

   DO WHILE .T.

      // --- Nome: nao pode ser vazio ---
      DO WHILE .T.
         ACCEPT "Nome do aluno: " TO cNome
         cNome := AllTrim( cNome )
         IF Len( cNome ) > 0
            EXIT
         ENDIF
         QOut( "Nome nao pode ser vazio." )
      ENDDO

      // --- Disciplina: 3 letras maiusculas ---
      DO WHILE .T.
         ACCEPT "Disciplina (3 letras maiusculas): " TO cDisc
         cDisc := AllTrim( cDisc )
         IF Len( cDisc ) == 3 .AND. cDisc == Upper( cDisc )
            EXIT
         ENDIF
         QOut( "Disciplina invalida. Exemplo: MAT" )
      ENDDO

      // --- Nota 1: entre 0 e 10 ---
      DO WHILE .T.
         ACCEPT "Nota 1 (0 a 10): " TO cEntrada
         nNota1 := Val( cEntrada )
         IF nNota1 >= 0 .AND. nNota1 <= 10
            EXIT
         ENDIF
         QOut( "Nota deve ficar entre 0 e 10." )
      ENDDO

      // --- Nota 2: entre 0 e 10 ---
      DO WHILE .T.
         ACCEPT "Nota 2 (0 a 10): " TO cEntrada
         nNota2 := Val( cEntrada )
         IF nNota2 >= 0 .AND. nNota2 <= 10
            EXIT
         ENDIF
         QOut( "Nota deve ficar entre 0 e 10." )
      ENDDO

      nMedia := ( nNota1 + nNota2 ) / 2

      QOut( "" )
      QOut( "Aluno......: " + cNome )
      QOut( "Disciplina.: " + cDisc )
      QOut( "Nota 1.....: " + AllTrim( Str( nNota1, 5, 2 ) ) )
      QOut( "Nota 2.....: " + AllTrim( Str( nNota2, 5, 2 ) ) )
      QOut( "Media......: " + AllTrim( Str( nMedia, 5, 2 ) ) )
      QOut( "" )

      // --- Continuar? ---
      ACCEPT "Deseja calcular outro? (S/N): " TO cResp
      cResp := Upper( AllTrim( cResp ) )

      IF cResp != "S"
         EXIT
      ENDIF

      QOut( "" )

   ENDDO

   QOut( "Programa encerrado." )

RETURN NIL
