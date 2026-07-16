FUNCTION Main()
 
   LOCAL cLonga := "Harbour"
   LOCAL cCurta := "Harb"
 
   SET EXACT OFF   // padrao do Harbour
 
   QOut( "cLonga = '" + cLonga + "'  |  cCurta = '" + cCurta + "'" )
   QOut( "" )
   QOut( "cLonga =  cCurta -> " + IIf( cLonga =  cCurta, ".T.", ".F." ) )  // .T.
   QOut( "cLonga == cCurta -> " + IIf( cLonga == cCurta, ".T.", ".F." ) )  // .F.
 
RETURN NIL
