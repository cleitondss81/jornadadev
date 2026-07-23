/*
 * Jogadas:  PE = PEDRA   PA = PAPEL   TE = TESOURA
 */

FUNCTION Main()

   LOCAL cJogador
   LOCAL cCpu
   LOCAL cVencedor
   LOCAL cContinua := "S"

   DO WHILE cContinua == "S"

      CLS
      ? "=== JOKENPO ==="
      ? "PE = PEDRA   PA = PAPEL   TE = TESOURA"
      ?

      cJogador := LerJogada()

      IF !ValidarJogada( cJogador )
         ? "Jogada invalida! Use PE, PA ou TE."
      ELSE
         cCpu      := SortearJogadaCPU()
         cVencedor := DefinirVencedor( cJogador, cCpu )
         MostrarResultado( cJogador, cCpu, cVencedor )
      ENDIF

      ?
      cContinua := LerResposta( "Jogar de novo? (S/N): " )

   ENDDO

   ? "Ate a proxima!"

   RETURN NIL


// Le a jogada do usuario
FUNCTION LerJogada()

   LOCAL cTexto := Space( 2 )

   ACCEPT "Sua jogada (PE/PA/TE): " TO cTexto

   RETURN Upper( AllTrim( cTexto ) )


// Le uma resposta simples do usuario
FUNCTION LerResposta( cMensagem )

   LOCAL cTexto := Space( 1 )

   ACCEPT cMensagem TO cTexto

   RETURN Upper( AllTrim( cTexto ) )


// Sorteia a jogada do computador
FUNCTION SortearJogadaCPU()

   LOCAL nSorteio := hb_RandomInt( 1, 3 )
   LOCAL cJogada  := ""

   // Se o seu Harbour nao tiver hb_RandomInt, troque a linha acima por:
   // LOCAL nSorteio := Int( Seconds() * 100 ) % 3 + 1

   DO CASE
   CASE nSorteio == 1
      cJogada := "PE"
   CASE nSorteio == 2
      cJogada := "PA"
   OTHERWISE
      cJogada := "TE"
   ENDCASE

   RETURN cJogada


// Devolve .T. se a jogada digitada for valida
FUNCTION ValidarJogada( cJogada )

   LOCAL lValida := .F.

   IF cJogada == "PE" .OR. cJogada == "PA" .OR. cJogada == "TE"
      lValida := .T.
   ENDIF

   RETURN lValida


// Decide quem ganhou: "JOGADOR", "CPU" ou "EMPATE"
FUNCTION DefinirVencedor( cJogada1, cJogada2 )

   LOCAL cVencedor := "CPU"

   DO CASE
   CASE cJogada1 == cJogada2
      cVencedor := "EMPATE"

   CASE cJogada1 == "PE" .AND. cJogada2 == "TE"   // pedra quebra tesoura
      cVencedor := "JOGADOR"

   CASE cJogada1 == "PA" .AND. cJogada2 == "PE"   // papel embrulha pedra
      cVencedor := "JOGADOR"

   CASE cJogada1 == "TE" .AND. cJogada2 == "PA"   // tesoura corta papel
      cVencedor := "JOGADOR"
   ENDCASE

   RETURN cVencedor


// Mostra o resultado da rodada
FUNCTION MostrarResultado( cJogador, cCpu, cVencedor )

   ?
   ? "Voce jogou : " + NomeJogada( cJogador )
   ? "CPU jogou  : " + NomeJogada( cCpu )
   ?

   DO CASE
   CASE cVencedor == "EMPATE"
      ? ">>> EMPATE!"
   CASE cVencedor == "JOGADOR"
      ? ">>> VOCE GANHOU!"
   OTHERWISE
      ? ">>> A CPU GANHOU!"
   ENDCASE

   RETURN NIL


// Converte a sigla no nome da jogada
FUNCTION NomeJogada( cJogada )

   LOCAL cNome := ""

   DO CASE
   CASE cJogada == "PE"
      cNome := "PEDRA"
   CASE cJogada == "PA"
      cNome := "PAPEL"
   OTHERWISE
      cNome := "TESOURA"
   ENDCASE

   RETURN cNome