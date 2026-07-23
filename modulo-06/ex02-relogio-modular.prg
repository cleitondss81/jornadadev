#define TECLA_ESC  27

FUNCTION Main()

   LOCAL nSegundos := 0
   LOCAL cHora     := ""
   LOCAL nTecla    := 0

   CLS
   @ 1, 5 SAY "RELOGIO DIGITAL - Harbour   (ESC para sair)"

   DO WHILE nSegundos < 30

      cHora := ObterHora()
      cHora := FormatarHora( cHora )
      ExibirHora( cHora )

      nTecla := Inkey( 1 )          // espera 1 segundo e le o teclado
      IF nTecla == TECLA_ESC
         EXIT
      ENDIF

      nSegundos := nSegundos + 1

   ENDDO

   @ 6, 5 SAY "Fim do relogio."

   RETURN NIL


// Retorna a hora atual do sistema
FUNCTION ObterHora()

   LOCAL cHora := Time()

   RETURN cHora


// Devolve a hora no formato HH:MM:SS
FUNCTION FormatarHora( cHora )

   LOCAL cHH := SubStr( cHora, 1, 2 )
   LOCAL cMM := SubStr( cHora, 4, 2 )
   LOCAL cSS := SubStr( cHora, 7, 2 )

   RETURN cHH + ":" + cMM + ":" + cSS


// Mostra a hora na tela
FUNCTION ExibirHora( cHora )

   @ 3, 5 SAY "Hora atual: " + cHora

   RETURN NIL