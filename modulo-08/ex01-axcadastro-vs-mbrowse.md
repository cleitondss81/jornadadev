a. Quando usar AxCadastro e quando usar mBrowse? (com exemplo)

AxCadastro é o CRUD "pronto e rápido". Você passa a tabela e ele já monta o browse (a listagem) e as telas de Incluir / Alterar / Visualizar / Excluir automaticamente, lendo tudo do dicionário (SX3). É ideal para um cadastro simples, sem regras especiais de tela, quando o objetivo é subir algo funcionando com pouquíssimo código.

Exemplo: um cadastro de "Pets" (ZA1) recém-criado, só para conseguir incluir/consultar registros durante o desenvolvimento. Uma função com AxCadastro("ZA1","Pets", , "1", , , , .F.) já resolve.

----------------------------------------------------------------------------------------

b. Três coisas que o mBrowse faz e o AxCadastro não faz :

1 - Legendas coloridas (aColors) — pinta cada linha do browse conforme uma condição (ex.: pets idosos em vermelho). O AxCadastro não oferece esse controle de cor por regra.

2 - Menu de ações customizado (aRotina) — você define quais opções aparecem e a qual função cada uma chama, além de acrescentar botões próprios (tipo 6 – customizado), como "Histórico". No AxCadastro o menu é fixo.

3 - Filtro pré-definido (cFiltro) — abre o browse já filtrado por uma expressão (ex.: só o mês atual). O AxCadastro mostra a tabela inteira.


----------------------------------------------------------------------------------------

c. Na configuração de legendas ( aColors ), por que a regra ".T." deve ficar por último?

Porque as regras do aColors são avaliadas de cima para baixo, e vence a primeira que der verdadeiro. A regra ".T." é sempre verdadeira, então ela funciona como o "caso padrão" (o else, o verde/os demais). Se ela ficasse em primeiro (ou no meio), toda linha bateria nela imediatamente e as regras seguintes nunca seriam testadas — todos os registros sairiam com a mesma cor. Deixando o ".T." por último, ele só é alcançado quando nenhuma das condições específicas (vermelho para idoso, amarelo para hoje) foi satisfeita.

----------------------------------------------------------------------------------------

d. Qual a diferença entre um campo Virtual (X3_RELACAO) e um gatilho (SX7) para preencher
o nome do cliente?

Campo Virtual (X3_CONTEXT = Virtual + X3_RELACAO) O campo não existe fisicamente na tabela — não ocupa coluna no banco. Ele é calculado em tempo de exibição por uma expressão (ex.: POSICIONE("SA1",1,xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA,"A1_NOME")). Como não é gravado, ele sempre reflete o valor atual da SA1: se o cliente mudar de nome, o virtual mostra o nome novo automaticamente. Em compensação, não dá para pesquisar/indexar por ele nem usá-lo em relatório como dado próprio, porque não está armazenado.

Gatilho (SX7) O campo destino é real (existe fisicamente na tabela). O gatilho apenas dispara no momento da digitação: quando você preenche o ZA1_CLIENT, ele executa a regra e grava o nome no campo real. Vantagem: o valor fica persistido, dá para indexar, filtrar e imprimir. Desvantagem: é uma foto do momento — se o cliente for renomeado depois na SA1, o valor gravado no ZA1 continua o antigo até alguém reeditar o registro.

Em uma frase: o virtual é sempre atual mas não é gravado (calcula na hora); o gatilho grava de verdade mas pode ficar defasado. Use virtual quando só quer exibir e sempre refletir a origem; use gatilho quando precisa do dado gravado para busca/relatório.