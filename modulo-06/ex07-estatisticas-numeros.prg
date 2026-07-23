/*
 * Exercicio 7 - Estatisticas de 10 numeros
 * Compilar: hbmk2 ex07-estatisticas-numeros.prg
 */

FUNCTION Main()

   LOCAL aNum := {}                 // array vazio
   LOCAL nI
   LOCAL cTexto
   LOCAL nSoma  := 0
   LOCAL nMedia := 0
   LOCAL nTotal := 10

   CLS
   ? "=== ESTATISTICAS DE 10 NUMEROS ==="
   ?

   // le os 10 numeros e guarda no array
   FOR nI := 1 TO nTotal
      cTexto := Space( 15 )
      ACCEPT "Numero " + AllTrim( Str( nI ) ) + ": " TO cTexto
      AAdd( aNum, Val( cTexto ) )
   NEXT

   // ordena em ordem crescente
   ASort( aNum )

   // soma
   FOR nI := 1 TO nTotal
      nSoma := nSoma + aNum[ nI ]
   NEXT

   nMedia := nSoma / nTotal

   // exibe os numeros ordenados
   ?
   ? "--- Numeros em ordem crescente ---"
   FOR nI := 1 TO nTotal
      ?? AllTrim( Str( aNum[ nI ] ) ) + "  "
   NEXT

   ?
   ?
   ? "Soma  : " + AllTrim( Str( nSoma ) )
   ? "Media : " + AllTrim( Str( nMedia, 15, 2 ) )
   ? "Menor : " + AllTrim( Str( aNum[ 1 ] ) )
   ? "Maior : " + AllTrim( Str( aNum[ Len( aNum ) ] ) )

   ?
   ? "Pressione uma tecla para sair..."
   Inkey( 0 )

   RETURN NIL
