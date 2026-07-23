/*
 * Exercicio 6 - Dias da semana por indice
 * Compilar: hbmk2 ex06-dias-da-semana.prg
 */

FUNCTION Main()

   LOCAL aDias
   LOCAL nDia
   LOCAL cTexto := Space( 2 )

   // array literal com os 7 dias (indice comeca em 1)
   aDias := { "Domingo", "Segunda", "Terca", "Quarta", ;
              "Quinta", "Sexta", "Sabado" }

   CLS
   ? "=== DIAS DA SEMANA ==="
   ? "1-Domingo  2-Segunda  3-Terca  4-Quarta  5-Quinta  6-Sexta  7-Sabado"
   ?

   ACCEPT "Digite um numero de 1 a 7: " TO cTexto
   nDia := Val( cTexto )

   IF nDia >= 1 .AND. nDia <= 7
      ? "O dia " + AllTrim( Str( nDia ) ) + " e: " + aDias[ nDia ]
   ELSE
      ? "Numero invalido! Digite um valor entre 1 e 7."
   ENDIF

   ?
   ? "Pressione uma tecla para sair..."
   Inkey( 0 )

   RETURN NIL