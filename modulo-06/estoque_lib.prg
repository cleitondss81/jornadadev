FUNCTION Menu()

   LOCAL cOpcao

   ? "================================="
   ? " CONTROLE DE ESTOQUE SIMPLIFICADO"
   ? "================================="
   ? "1 - Cadastrar produto"
   ? "2 - Listar produtos"
   ? "3 - Entrada de estoque"
   ? "4 - Saida de estoque"
   ? "5 - Buscar produto por codigo"
   ? "6 - Relatorio do estoque"
   ? "0 - Sair"
   ? "================================="

   ACCEPT "Escolha uma opcao: " TO cOpcao

RETURN Val( cOpcao )



FUNCTION CadastrarProduto( aProdutos )

   LOCAL cCodigo
   LOCAL cNome
   LOCAL cQuantidade
   LOCAL cPreco

   ACCEPT "Codigo do produto: " TO cCodigo

   IF Val( cCodigo ) <= 0
      ? "Codigo invalido."
      RETURN NIL
   ENDIF

   IF ProcurarCodigo( aProdutos, Val( cCodigo ) ) > 0
      ? "Codigo ja cadastrado."
      RETURN NIL
   ENDIF

   ACCEPT "Nome do produto: " TO cNome

   IF Empty( cNome )
      ? "Nome nao informado."
      RETURN NIL
   ENDIF

   ACCEPT "Quantidade: " TO cQuantidade

   IF Val( cQuantidade ) < 0
      ? "Quantidade invalida."
      RETURN NIL
   ENDIF

   ACCEPT "Preco unitario: " TO cPreco

   IF Val( cPreco ) <= 0
      ? "Preco invalido."
      RETURN NIL
   ENDIF

   AADD( aProdutos, ;
         { ;
         Val( cCodigo ), ;
         cNome, ;
         Val( cQuantidade ), ;
         Val( cPreco ) ;
         } )

   ? "Produto cadastrado com sucesso!"

RETURN NIL



FUNCTION ListarProdutos( aProdutos )

   LOCAL nI

   IF Len( aProdutos ) == 0
      ? "Nenhum produto cadastrado."
      RETURN NIL
   ENDIF

   ? "========== PRODUTOS =========="

   FOR nI := 1 TO Len( aProdutos )

      ? "Codigo.....:", aProdutos[nI][1]
      ? "Nome.......:", aProdutos[nI][2]
      ? "Quantidade.:", aProdutos[nI][3]
      ? "Preco......:", aProdutos[nI][4]
      ? "-----------------------------"

   NEXT

RETURN NIL



FUNCTION ProcurarCodigo( aProdutos, nCodigo )

   LOCAL nI

   FOR nI := 1 TO Len( aProdutos )

      IF aProdutos[nI][1] == nCodigo
         RETURN nI
      ENDIF

   NEXT

RETURN 0



FUNCTION EntradaEstoque( aProdutos )

   LOCAL cCodigo
   LOCAL cQuantidade
   LOCAL nPosicao

   ACCEPT "Codigo do produto: " TO cCodigo

   nPosicao := ProcurarCodigo( ;
                 aProdutos, ;
                 Val( cCodigo ) )

   IF nPosicao == 0
      ? "Produto nao encontrado."
      RETURN NIL
   ENDIF

   ACCEPT "Quantidade da entrada: " TO cQuantidade

   IF Val( cQuantidade ) <= 0
      ? "Quantidade invalida."
      RETURN NIL
   ENDIF

   aProdutos[nPosicao][3] += Val( cQuantidade )

   ? "Entrada realizada com sucesso!"

RETURN NIL



FUNCTION SaidaEstoque( aProdutos )

   LOCAL cCodigo
   LOCAL cQuantidade
   LOCAL nPosicao
   LOCAL nQtdSaida

   ACCEPT "Codigo do produto: " TO cCodigo

   nPosicao := ProcurarCodigo( ;
                 aProdutos, ;
                 Val( cCodigo ) )

   IF nPosicao == 0
      ? "Produto nao encontrado."
      RETURN NIL
   ENDIF

   ACCEPT "Quantidade da saida: " TO cQuantidade

   nQtdSaida := Val( cQuantidade )

   IF nQtdSaida <= 0
      ? "Quantidade invalida."
      RETURN NIL
   ENDIF

   IF nQtdSaida > aProdutos[nPosicao][3]
      ? "Estoque insuficiente."
      RETURN NIL
   ENDIF

   aProdutos[nPosicao][3] -= nQtdSaida

   ? "Saida realizada com sucesso!"

RETURN NIL



FUNCTION BuscarProduto( aProdutos )

   LOCAL cCodigo
   LOCAL nPosicao

   ACCEPT "Digite o codigo do produto: " TO cCodigo

   nPosicao := ProcurarCodigo( ;
                 aProdutos, ;
                 Val( cCodigo ) )

   IF nPosicao == 0

      ? "Produto nao encontrado."

   ELSE

      ? "Produto encontrado!"
      ? "Codigo.....:", aProdutos[nPosicao][1]
      ? "Nome.......:", aProdutos[nPosicao][2]
      ? "Quantidade.:", aProdutos[nPosicao][3]
      ? "Preco......:", aProdutos[nPosicao][4]

   ENDIF

RETURN NIL



FUNCTION RelatorioEstoque( aProdutos )

   LOCAL nI
   LOCAL nValorProduto
   LOCAL nTotal := 0

   IF Len( aProdutos ) == 0
      ? "Nenhum produto cadastrado."
      RETURN NIL
   ENDIF

   ? "======= RELATORIO DO ESTOQUE ======="

   FOR nI := 1 TO Len( aProdutos )

      nValorProduto := ;
         aProdutos[nI][3] * ;
         aProdutos[nI][4]

      ? "Produto....:", aProdutos[nI][2]
      ? "Quantidade.:", aProdutos[nI][3]
      ? "Valor.......:", nValorProduto
      ? "----------------------------------"

      nTotal += nValorProduto

   NEXT

   ? "TOTAL GERAL DO ESTOQUE:", nTotal

RETURN NIL