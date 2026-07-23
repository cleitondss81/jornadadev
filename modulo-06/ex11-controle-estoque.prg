FUNCTION Main()

   LOCAL aProdutos := {}
   LOCAL nOpcao := -1

   DO WHILE nOpcao <> 0

      CLS

      nOpcao := Menu()

      DO CASE

      CASE nOpcao == 1
         CadastrarProduto( aProdutos )

      CASE nOpcao == 2
         ListarProdutos( aProdutos )

      CASE nOpcao == 3
         EntradaEstoque( aProdutos )

      CASE nOpcao == 4
         SaidaEstoque( aProdutos )

      CASE nOpcao == 5
         BuscarProduto( aProdutos )

      CASE nOpcao == 6
         RelatorioEstoque( aProdutos )

      CASE nOpcao == 0
         ? "Programa encerrado."

      OTHERWISE
         ? "Opcao invalida."

      ENDCASE

      IF nOpcao <> 0
         ?
         WAIT "Pressione qualquer tecla para continuar..."
      ENDIF

   ENDDO

RETURN NIL