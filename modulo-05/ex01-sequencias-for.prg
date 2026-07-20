FUNCTION Main()

   LOCAL nI

   // a |  1 a 100
   FOR nI := 1 TO 100
      ? nI
   NEXT

   // b | -50 a 50
   FOR nI := -50 TO 50
      ? nI
   NEXT

   // c |  80 a 5, decrescente
   FOR nI := 80 TO 5 STEP -1
      ? nI
   NEXT

RETURN NIL