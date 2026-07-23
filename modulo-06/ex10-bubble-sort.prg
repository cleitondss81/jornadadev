FUNCTION Main()

   LOCAL aNum := {}
   LOCAL nI

   CLS
   ? "=== BUBBLE SORT ==="

   // gera 10 numeros aleatorios de 1 a 100
   FOR nI := 1 TO 10
      AAdd( aNum, hb_RandomInt( 1, 100 ) )
      // Se nao tiver hb_RandomInt, troque por:
      // AAdd( aNum, Int( Seconds() * 1000 ) % 100 + 1 )
   NEXT

   ? "Antes de ordenar:"
   MostrarArray( aNum )

   BubbleSort( aNum )

   ?
   ? "Depois de ordenar (crescente):"
   MostrarArray( aNum )

   ?
   ? "Pressione uma tecla para sair..."
   Inkey( 0 )

   RETURN NIL


// Ordena o array em ordem crescente usando Bubble Sort
FUNCTION BubbleSort( aVetor )

   LOCAL nTam := Len( aVetor )
   LOCAL nI
   LOCAL nJ
   LOCAL nTemp

   FOR nI := 1 TO nTam - 1
      FOR nJ := 1 TO nTam - nI
         // se o vizinho da esquerda for maior, troca
         IF aVetor[ nJ ] > aVetor[ nJ + 1 ]
            nTemp            := aVetor[ nJ ]
            aVetor[ nJ ]     := aVetor[ nJ + 1 ]
            aVetor[ nJ + 1 ] := nTemp
         ENDIF
      NEXT
   NEXT

   RETURN NIL


// Mostra os elementos do array lado a lado
FUNCTION MostrarArray( aVetor )

   LOCAL nI

   FOR nI := 1 TO Len( aVetor )
      ?? AllTrim( Str( aVetor[ nI ] ) ) + "  "
   NEXT
   ?

   RETURN NIL