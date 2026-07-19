FUNCTION Main()

   LOCAL cEntrada := ""
   LOCAL nA := 0, nB := 0
   LOCAL cOp := ""

   // Ler o primeiro numero.
   ACCEPT "Primeiro numero: " TO cEntrada
   nA := Val( AllTrim( cEntrada ) )

   // Ler a operacao (+  -  *  /  ^  R).
   ACCEPT "Operacao (+ - * / ^ R): " TO cEntrada
   cOp := Upper( AllTrim( cEntrada ) )   // Upper para aceitar 'r' ou 'R'

   // O segundo numero so e necessario quando NÃO for raiz quadrada.
   IF cOp != "R"
      ACCEPT "Segundo numero.: " TO cEntrada
      nB := Val( AllTrim( cEntrada ) )
   ENDIF

   QOut( "" )

   // Decidir o que fazer conforme a operação.
   DO CASE
   CASE cOp == "+"
      QOut( "Resultado: " + Str( nA + nB, 12, 2 ) )

   CASE cOp == "-"
      QOut( "Resultado: " + Str( nA - nB, 12, 2 ) )

   CASE cOp == "*"
      QOut( "Resultado: " + Str( nA * nB, 12, 2 ) )

   CASE cOp == "/"
      // Proteger contra divisao por zero.
      IF nB == 0
         QOut( "Erro: nao e possivel dividir por zero." )
      ELSE
         QOut( "Resultado: " + Str( nA / nB, 12, 2 ) )
      ENDIF

   CASE cOp == "^"
      QOut( "Resultado: " + Str( nA ^ nB, 12, 2 ) )

   CASE cOp == "R"
      
      IF nA < 0
         QOut( "Erro: nao existe raiz de numero negativo." )
      ELSE
         QOut( "Resultado: " + AllTrim( Str( Sqrt( nA ), 12, 2 ) ) )
      ENDIF

   OTHERWISE
      QOut( "Operacao invalida!" )
   ENDCASE

RETURN NIL
