FUNCTION Main()
 
   LOCAL cEntrada  := ""
   LOCAL cNome     := ""
   LOCAL dNasc     := CToD( "" )
   LOCAL nPreco    := 0
   LOCAL nIdade    := 0
   LOCAL nDesconto := 0
   LOCAL nTotal    := 0
 
   // garante que a data seja lida como dd/mm/aaaa (padrao brasileiro)
   SET DATE FORMAT TO "dd/mm/yyyy"
 
   ACCEPT "Nome do cliente...: " TO cNome
 
   ACCEPT "Data de nascimento (dd/mm/aaaa): " TO cEntrada
   dNasc := CToD( cEntrada )
 
   ACCEPT "Preco do produto..: " TO cEntrada
   nPreco := Val( cEntrada )
 
   // idade aproximada em anos completos
   nIdade := Int( ( Date() - dNasc ) / 365 )
 
   // desconto de 12,5% apenas para maiores de 60 anos
   IF nIdade > 60
      nDesconto := nPreco * 0.125
   ENDIF
 
   nTotal := nPreco - nDesconto
 
   QOut( "" )
   QOut( "===== RESUMO =====" )
   QOut( "Cliente..: " + cNome )
   QOut( "Idade....: " + Str( nIdade, 3 ) + " anos" )
   QOut( "Preco....: " + Str( nPreco, 10, 2 ) )
   QOut( "Desconto.: " + Str( nDesconto, 10, 2 ) )
   QOut( "Total....: " + Str( nTotal, 10, 2 ) )
 
RETURN NIL
