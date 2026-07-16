FUNCTION Main()
 
   LOCAL nPi := 3.14159   // constante PI
   LOCAL cEntrada := ""
   LOCAL nRaio, nCateA, nCateB, nPeso, nAltura
   LOCAL nArea, nHipotenusa, nIMC
 
   // a) Area do circulo (PI x r^2)
   ACCEPT "Raio do circulo: " TO cEntrada
   nRaio := Val( cEntrada )
   nArea := nPi * ( nRaio ^ 2 )
 
   // b) Hipotenusa (raiz de a^2 + b^2)
   ACCEPT "Cateto A: " TO cEntrada
   nCateA := Val( cEntrada )
   ACCEPT "Cateto B: " TO cEntrada
   nCateB := Val( cEntrada )
   nHipotenusa := Sqrt( ( nCateA ^ 2 ) + ( nCateB ^ 2 ) )
 
   // c) IMC (peso / altura^2)
   ACCEPT "Peso (kg): " TO cEntrada
   nPeso := Val( cEntrada )
   ACCEPT "Altura (m): " TO cEntrada
   nAltura := Val( cEntrada )
   nIMC := nPeso / ( nAltura ^ 2 )
 
   QOut( "" )
   QOut( "Area do circulo: " + Str( nArea, 10, 2 ) )
   QOut( "Hipotenusa.....: " + Str( nHipotenusa, 10, 2 ) )
   QOut( "IMC............: " + Str( nIMC, 10, 2 ) )
 
RETURN NIL
