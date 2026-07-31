a. Por que existe o A1_FILIAL

A base do Protheus guarda os dados de todas as filiais juntos, nas mesmas tabelas. O campo de filial (A1_FILIAL na SA1, ZA1_FILIAL na ZA1) é quem marca de qual filial é cada registro, pra uma filial não ver os dados da outra. Por isso toda tabela precisa dele. Se a tabela é exclusiva por filial, ele vem preenchido; se é compartilhada, fica vazio.



b. O que a xFilial() tem a ver

Toda busca/gravação começa pela filial. A xFilial() devolve o valor certo desse campo automaticamente: se a tabela é exclusiva, retorna a filial logada; se é compartilhada, retorna vazio.
Se escrevesse a filial na mão (ex.: "01"), o código ficaria preso nessa filial e quebraria ao rodar em outra ou se o compartilhamento mudasse, podendo até gravar na filial errada.



Resumo: A1_FILIAL separa os dados por filial; xFilial() entrega o valor certo desse campo sozinha. Na mão, trava o código e quebra com mais de uma filial.