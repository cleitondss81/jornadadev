a. Qual é a função do AppServer?
É o "motor" do Protheus. Ele fica no servidor, executa os programas do sistema e faz a ponte entre a tela do usuário e o banco de dados. Sem ele no ar, ninguém consegue usar o Protheus.

b. O que é o RPO?
É o arquivo onde ficam guardados todos os programas do Protheus (os padrões da TOTVS e as customizações). É de lá que o AppServer "puxa" as rotinas para funcionar. Atualizar o sistema é atualizar o RPO.

c. Para que serve o Configurador (SIGACFG)?
É o módulo de administração do sistema. Nele você cadastra empresas e filiais, cria usuários e libera acessos, ajusta parâmetros (MV_) e mexe no dicionário de dados. É onde se configura como o Protheus vai se comportar.

d. Qual a diferença entre campo Real e campo Virtual no SX3?
Campo Real é gravado de verdade no banco de dados — ele guarda a informação. Campo Virtual não é gravado: o valor aparece na tela mas é só calculado na hora, geralmente para mostrar algo de apoio. Resumindo: Real guarda, Virtual só exibe.