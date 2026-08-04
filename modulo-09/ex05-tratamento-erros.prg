FUNCTION Main()

   LOCAL nA   := 10
   LOCAL nB   := 0
   LOCAL nRes
   LOCAL oErro
   LOCAL bAntigo

   // ErrorBlock: manda o Harbour "quebrar" a sequencia (Break)
   // e entregar o objeto de erro no RECOVER, em vez de encerrar.

   bAntigo := ErrorBlock( { |e| Break( e ) } )

   BEGIN SEQUENCE

      // a - provoca a divisao por zero de proposito
      nRes := nA / nB

      // so chega aqui se NAO der erro
      QOut( "Resultado: " + Str( nRes ) )

   RECOVER USING oErro

      // b/c - caiu aqui por causa do erro -> mostra a descricao
      QOut( "Erro capturado: " + oErro:Description )

   END SEQUENCE

   // restaura o tratamento de erro padrao
   ErrorBlock( bAntigo )

   // d - o programa continua normalmente depois do tratamento
   QOut( "O programa continua de pe!" )

   RETURN NIL