FUNCTION Main()

   LOCAL cEntrada := ""
   LOCAL nA, nB

   // Ler o primeiro numero (vem como texto, Val converte em numero).
   ACCEPT "Digite o primeiro numero: " TO cEntrada
   nA := Val( AllTrim( cEntrada ) )

   // Ler o segundo numero.
   ACCEPT "Digite o segundo numero: " TO cEntrada
   nB := Val( AllTrim( cEntrada ) )

   QOut( "" )

   // Primeiro tratamos o caso "iguais".
   IF nA == nB
      QOut( "Os dois valores sao iguais: " + Str( nA, 10, 2 ) )
   ELSE
      // Se sao diferentes, decidimos quem e o maior.
      IF nA > nB
         QOut( "Maior: " + Str( nA, 10, 2 ) )
         QOut( "Menor: " + Str( nB, 10, 2 ) )
      ELSE
         QOut( "Maior: " + Str( nB, 10, 2 ) )
         QOut( "Menor: " + Str( nA, 10, 2 ) )
      ENDIF
   ENDIF

RETURN NIL
