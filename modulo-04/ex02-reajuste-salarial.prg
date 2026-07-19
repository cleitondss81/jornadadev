FUNCTION Main()

   LOCAL cEntrada  := ""
   LOCAL nSalario  := 0
   LOCAL nPercent  := 0
   LOCAL nNovo     := 0

   // Ler o salario atual (texto -> numero).
   ACCEPT "Salario atual: " TO cEntrada
   nSalario := Val( AllTrim( cEntrada ) )

   // Descobrir o percentual de reajuste conforme a faixa.
   IF nSalario < 1000
      nPercent := 15
   ELSEIF nSalario <= 2000        // de 1000 ate 2000
      nPercent := 12
   ELSEIF nSalario <= 4000        // de 2000 ate 4000
      nPercent := 8
   ELSE                           // acima de 4000
      nPercent := 5
   ENDIF

   // Calcular o novo salario.
   // Ex.: 12% -> salario + (salario * 12 / 100)
   nNovo := nSalario + ( nSalario * nPercent / 100 )

   // Mostrar o resultado.
   QOut( "" )
   QOut( "Salario atual..: " + Str( nSalario, 10, 2 ) )
   QOut( "Reajuste.......: " + Str( nPercent, 3 ) + "%" )
   QOut( "Novo salario...: " + Str( nNovo, 10, 2 ) )

RETURN NIL
