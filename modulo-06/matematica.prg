/*
 * matematica.prg - biblioteca de funcoes matematicas
 */

// Calcula o fatorial de N (0! = 1). Negativo devolve 0.
FUNCTION FatorialN( nN )

   LOCAL nFatorial := 1
   LOCAL nI

   IF nN < 0
      RETURN 0
   ENDIF

   FOR nI := 2 TO nN
      nFatorial := nFatorial * nI
   NEXT

   RETURN nFatorial


// Devolve .T. se N for primo
FUNCTION EhPrimo( nN )

   LOCAL lPrimo := .T.
   LOCAL nI

   IF nN < 2
      RETURN .F.
   ENDIF

   FOR nI := 2 TO Int( nN / 2 )
      IF nN % nI == 0
         lPrimo := .F.
         EXIT
      ENDIF
   NEXT

   RETURN lPrimo


// Maximo divisor comum (algoritmo de Euclides)
FUNCTION MDC( nA, nB )

   LOCAL nResto

   nA := Abs( nA )
   nB := Abs( nB )

   DO WHILE nB != 0
      nResto := nA % nB
      nA     := nB
      nB     := nResto
   ENDDO

   RETURN nA


// Minimo multiplo comum
FUNCTION MMC( nA, nB )

   LOCAL nMdc

   IF nA == 0 .OR. nB == 0
      RETURN 0
   ENDIF

   nMdc := MDC( nA, nB )

   RETURN Abs( nA * nB ) / nMdc