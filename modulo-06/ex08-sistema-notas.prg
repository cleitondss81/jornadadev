/*
 * Cada linha do array: { nome, n1, n2, n3, n4 }
 */

FUNCTION Main()

   LOCAL aAlunos := {}
   LOCAL nQtd
   LOCAL nI
   LOCAL cNome
   LOCAL nN1, nN2, nN3, nN4
   LOCAL nMedia
   LOCAL cTexto

   CLS
   ? "=== SISTEMA DE NOTAS ==="
   ?

   cTexto := Space( 3 )
   ACCEPT "Quantos alunos? " TO cTexto
   nQtd := Val( cTexto )

   FOR nI := 1 TO nQtd
      ?
      ? "--- Aluno " + AllTrim( Str( nI ) ) + " ---"

      cNome := Space( 30 )
      ACCEPT "Nome: " TO cNome
      cNome := AllTrim( cNome )

      nN1 := LerNota( "Nota 1: " )
      nN2 := LerNota( "Nota 2: " )
      nN3 := LerNota( "Nota 3: " )
      nN4 := LerNota( "Nota 4: " )

      // guarda a linha no array multidimensional
      AAdd( aAlunos, { cNome, nN1, nN2, nN3, nN4 } )
   NEXT

   ?
   ? "=== APROVADOS (media >= 7) ==="
   FOR nI := 1 TO Len( aAlunos )
      nMedia := ( aAlunos[ nI ][ 2 ] + aAlunos[ nI ][ 3 ] + ;
                  aAlunos[ nI ][ 4 ] + aAlunos[ nI ][ 5 ] ) / 4
      IF nMedia >= 7
         ? aAlunos[ nI ][ 1 ] + " - Media: " + AllTrim( Str( nMedia, 6, 2 ) )
      ENDIF
   NEXT

   ?
   ? "=== REPROVADOS (media < 7) ==="
   FOR nI := 1 TO Len( aAlunos )
      nMedia := ( aAlunos[ nI ][ 2 ] + aAlunos[ nI ][ 3 ] + ;
                  aAlunos[ nI ][ 4 ] + aAlunos[ nI ][ 5 ] ) / 4
      IF nMedia < 7
         ? aAlunos[ nI ][ 1 ] + " - Media: " + AllTrim( Str( nMedia, 6, 2 ) )
      ENDIF
   NEXT

   ?
   ? "Pressione uma tecla para sair..."
   Inkey( 0 )

   RETURN NIL


// Le uma nota digitada pelo usuario
FUNCTION LerNota( cMensagem )

   LOCAL cTexto := Space( 6 )

   ACCEPT cMensagem TO cTexto

   RETURN Val( cTexto )