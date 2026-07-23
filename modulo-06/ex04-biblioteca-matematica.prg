/*
 * principal.prg - testa a biblioteca matematica.prg
 * Compilar: hbmk2 principal.prg
 */

SET PROCEDURE TO matematica.prg

FUNCTION Main()

   LOCAL nI

   CLS
   ? "=== TESTE DA BIBLIOTECA MATEMATICA ==="

   // 1) Fatorial
   ?
   ? "--- FatorialN ---"
   FOR nI := 0 TO 6
      ? "Fatorial de " + AllTrim( Str( nI ) ) + " = " + ;
        AllTrim( Str( FatorialN( nI ) ) )
   NEXT

   // 2) Primo
   ?
   ? "--- EhPrimo ---"
   FOR nI := 1 TO 10
      IF EhPrimo( nI )
         ? AllTrim( Str( nI ) ) + " e primo"
      ELSE
         ? AllTrim( Str( nI ) ) + " NAO e primo"
      ENDIF
   NEXT

   // 3) MDC
   ?
   ? "--- MDC ---"
   ? "MDC( 12, 18 ) = " + AllTrim( Str( MDC( 12, 18 ) ) )
   ? "MDC( 25, 30 ) = " + AllTrim( Str( MDC( 25, 30 ) ) )

   // 4) MMC
   ?
   ? "--- MMC ---"
   ? "MMC( 4, 6 )   = " + AllTrim( Str( MMC( 4, 6 ) ) )
   ? "MMC( 12, 18 ) = " + AllTrim( Str( MMC( 12, 18 ) ) )

   ?
   ? "Pressione uma tecla para sair..."
   Inkey( 0 )

   RETURN NIL
