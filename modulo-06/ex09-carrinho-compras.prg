/*
 * Cada item do carrinho: { nome, preco }
 */

FUNCTION Main()

   LOCAL aCarrinho := {}
   LOCAL cNome
   LOCAL nPreco
   LOCAL cResposta := "S"
   LOCAL nI
   LOCAL nTotal := 0

   CLS
   ? "=== MINI CARRINHO DE COMPRAS ==="

   DO WHILE cResposta == "S"

      ?
      cNome := Space( 30 )
      ACCEPT "Nome do produto: " TO cNome
      cNome := AllTrim( cNome )

      nPreco := LerPreco( "Preco: R$ " )

      // guarda o item no carrinho
      AAdd( aCarrinho, { cNome, nPreco } )

      ?
      cResposta := LerResposta( "Adicionar outro item? (S/N): " )

   ENDDO

   ?
   ? "=== ITENS DO CARRINHO ==="
   FOR nI := 1 TO Len( aCarrinho )
      ? aCarrinho[ nI ][ 1 ] + " - R$ " + ;
        AllTrim( Str( aCarrinho[ nI ][ 2 ], 10, 2 ) )
      nTotal := nTotal + aCarrinho[ nI ][ 2 ]
   NEXT

   ?
   ? "TOTAL: R$ " + AllTrim( Str( nTotal, 10, 2 ) )
   ? "Quantidade de itens: " + AllTrim( Str( Len( aCarrinho ) ) )

   ?
   ? "Pressione uma tecla para sair..."
   Inkey( 0 )

   RETURN NIL


// Le o preco digitado pelo usuario
FUNCTION LerPreco( cMensagem )

   LOCAL cTexto := Space( 10 )

   ACCEPT cMensagem TO cTexto

   RETURN Val( cTexto )


// Le uma resposta S/N
FUNCTION LerResposta( cMensagem )

   LOCAL cTexto := Space( 1 )

   ACCEPT cMensagem TO cTexto

   RETURN Upper( AllTrim( cTexto ) )