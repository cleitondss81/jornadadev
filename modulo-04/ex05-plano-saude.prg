FUNCTION Main()

   LOCAL cEntrada  := ""
   LOCAL nIdade    := 0
   LOCAL nDepend   := 0
   LOCAL nBase     := 0
   LOCAL nAdicional := 0
   LOCAL nTotal    := 0

   // Ler idade e n£mero de dependentes.
   ACCEPT "Idade.................: " TO cEntrada
   nIdade := Val( AllTrim( cEntrada ) )

   ACCEPT "N£mero de dependentes.: " TO cEntrada
   nDepend := Val( AllTrim( cEntrada ) )

   // Definir o valor base conforme a faixa et ria.
   DO CASE
   CASE nIdade <= 25
      nBase := 180
   CASE nIdade <= 40        // de 26 a 40
      nBase := 260
   CASE nIdade <= 60        // de 41 a 60
      nBase := 380
   OTHERWISE                // acima de 60
      nBase := 520
   ENDCASE

   // Adicional: R$ 90 por dependente.
   nAdicional := nDepend * 90

   // Total do plano.
   nTotal := nBase + nAdicional

   // Mostrar o resumo.
   QOut( "" )
   QOut( "===== PLANO DE SAUDE =====" )
   QOut( "Idade..............: " + AllTrim( Str( nIdade, 3 ) ) + " anos" )
   QOut( "Valor base.........: " + AllTrim( Str( nBase, 10, 2 ) ) )
   QOut( "Dependentes........: " + AllTrim( Str( nDepend, 3 ) ) + " (R$ " + AllTrim( Str( nAdicional, 10, 2 ) ) + ")" )
   QOut( "TOTAL MENSAL.......: R$ " + AllTrim( Str( nTotal, 10, 2 ) ) )

RETURN NIL
