FUNCTION Main()
 
   LOCAL cEntrada := ""
   LOCAL nMes     := 0
   LOCAL cNome    := ""
 
   // Ler o numero do mˆs (texto -> numero).
   ACCEPT "Numero do mes (1 a 12): " TO cEntrada
   nMes := Val( AllTrim( cEntrada ) )
 
   // Descobrir o nome conforme o numero.
   DO CASE
   CASE nMes == 1
      cNome := "Janeiro"
   CASE nMes == 2
      cNome := "Fevereiro"
   CASE nMes == 3
      cNome := "Mar‡o"
   CASE nMes == 4
      cNome := "Abril"
   CASE nMes == 5
      cNome := "Maio"
   CASE nMes == 6
      cNome := "Junho"
   CASE nMes == 7
      cNome := "Julho"
   CASE nMes == 8
      cNome := "Agosto"
   CASE nMes == 9
      cNome := "Setembro"
   CASE nMes == 10
      cNome := "Outubro"
   CASE nMes == 11
      cNome := "Novembro"
   CASE nMes == 12
      cNome := "Dezembro"
   OTHERWISE
      cNome := "Mˆs invalido"
   ENDCASE
 
   QOut( "" )
   QOut( cNome )
 
RETURN NIL
