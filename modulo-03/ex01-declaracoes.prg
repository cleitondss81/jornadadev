FUNCTION Main()
 
   LOCAL cNome      := "Ana Silva"   // caractere -> nome do funcionario
   LOCAL nSalario   := 3500.00       // numerico  -> salario bruto
   LOCAL lAtivo     := .T.           // logico    -> esta ativo?
   LOCAL dAdmissao  := CToD("15/07/2020") // data -> data de admissao
   LOCAL cDepto     := "TI01"        // caractere -> codigo do departamento
 
   QOut( "Nome......: " + cNome )
   QOut( "Salario...: " + Str( nSalario, 10, 2 ) )
   QOut( "Ativo.....: " + IIf( lAtivo, "Sim", "Nao" ) )
   QOut( "Admissao..: " + DToC( dAdmissao ) )
   QOut( "Depto.....: " + cDepto )
 
RETURN NIL
