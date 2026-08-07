# TCC — Controle de Não Conformidades de Fornecedores (ISO 9001)

**Curso:** Harbour/ADVPL — Do Zero ao Protheus
**Módulo:** Compras (SIGACOM)
**Autor:** Cleiton
**Data:** Agosto/2026

---

## 1. Descrição do sistema

A Indústria XYZ precisa monitorar as **não conformidades na entrada de materiais** dos seus fornecedores para se manter em conformidade com a certificação **ISO 9001**.

Este projeto resolve isso com duas tabelas novas no módulo de Compras:

- **ZZ1 — Controle de Fornecimento:** guarda o certificado de qualidade de cada fornecedor (validade e tolerância aceita de não conformidade).
- **ZZ2 — Ocorrências do Fornecedor:** registra cada entrega/ocorrência, com a quantidade conforme e não conforme por produto.

O sistema mostra, com **legendas coloridas**, quais certificados estão vencidos ou perto de vencer e quais entregas passaram da tolerância do certificado.

O projeto está inteiro escrito em **ADVPL**, seguindo o que o curso cobriu: dicionário de dados, rotinas mBrowse, validações, gatilhos, tratamento de erros com `BEGIN SEQUENCE`, biblioteca de funções reaproveitáveis e uma classe (POO).

> **Compatibilidade:** todo o código usa **ADVPL clássico**, compatível com o **Protheus 8**. Não há uso de MVC (`FWMBrowse`, `ModelDef`/`ViewDef`), nem TLPP, nem funções de versões novas. Includes: `protheus.ch` e `rwmake.ch`. As mensagens usam `MsgAlert` e `MsgYesNo`, e a persistência usa `RecLock`/`MsUnLock` dentro de `BEGIN SEQUENCE`.

---

## 2. Estrutura de arquivos

```
TCC/
├── Dados-e-Dicionario/
│   ├── sx2990.dbf         ← Dicionário de Tabelas (SX2)
│   ├── sx3990.dbf         ← Dicionário de Campos (SX3)
│   ├── six990.dbf         ← Dicionário de Índices (SIX)
│   ├── sx7990.dbf         ← Dicionário de Gatilhos (SX7)
│   ├── sxb990.dbf         ← Dicionário de Consultas-padrão / F3 (SXB)
│   ├── sigacom.xnu        ← Menu do módulo de Compras
│   ├── zz1990.dbf         ← Tabela ZZ1 (com dados de teste)
│   ├── zz2990.dbf         ← Tabela ZZ2 (com dados de teste)
│   ├── sa2990.dbf         ← Fornecedores de teste (SA2)
│   └── sb1990.dbf         ← Produtos de teste (SB1)
├── STTZZ1.PRW             ← Rotina mBrowse da ZZ1 (+ exclusão e botão Ocorrências)
├── STTZZ2.PRW             ← Rotina mBrowse da ZZ2 (+ versão filtrada + legenda)
├── STTZZLIB.PRW          ← Biblioteca de funções comuns
├── STTZZCLS.PRW          ← Classe ADVPL ZCertificado (diferencial POO)
├── STTZZTST.PRW          ← Gerador de massa de dados de teste
├── TCC-Documentacao.docx ← Documentação completa com prints das telas
└── README.md             ← Este documento
```

> O dicionário está entregue como os arquivos **.dbf** exportados do ambiente (SX2/SX3/SIX/SX7/SXB). O conteúdo das tabelas ZZ1/ZZ2 também está descrito, de forma legível, nas seções 3 a 8 deste README.

---

## 3. Layout das tabelas

### 3.1 ZZ1 — Controle de Fornecimento (Compartilhada)

| Título | Campo | Tipo | Tam | Dec | Contexto |
|---|---|---|---|---|---|
| Filial | ZZ1_FILIAL | C | 2 | 0 | Real |
| Código | ZZ1_CODIGO | C | 6 | 0 | Real |
| Cód. Fornecedor | ZZ1_FORNEC | C | 6 | 0 | Real |
| Loja Fornecedor | ZZ1_LOJAFO | C | 2 | 0 | Real |
| Nome Fornecedor | ZZ1_NOMEFO | C | 40 | 0 | **Virtual** |
| Dados Certificado | ZZ1_CERTIF | C | 256 | 0 | Real |
| Val. Certificado | ZZ1_VALCER | D | 8 | 0 | Real |
| Tolerância (%) | ZZ1_TOLERA | N | 5 | 2 | Real |
| Qtd. Conforme | ZZ1_TOTOK | N | 12 | 2 | Real |
| Qtd. Não Conforme | ZZ1_TOTNOK | N | 12 | 2 | Real |

**Índices (SIX):**

1. `ZZ1_FILIAL + ZZ1_CODIGO` — chave primária
2. `ZZ1_FILIAL + ZZ1_FORNEC + ZZ1_LOJAFO` — por fornecedor
3. `ZZ1_FILIAL + DTOS(ZZ1_VALCER)` — por validade do certificado

### 3.2 ZZ2 — Ocorrências do Fornecedor (Compartilhada)

| Título | Campo | Tipo | Tam | Dec | Contexto |
|---|---|---|---|---|---|
| Filial | ZZ2_FILIAL | C | 2 | 0 | Real |
| Controle (→ZZ1) | ZZ2_CONFOR | C | 6 | 0 | Real |
| Cód. Fornecedor | ZZ2_FORNEC | C | 6 | 0 | Real |
| Loja Fornecedor | ZZ2_LOJAFO | C | 2 | 0 | Real |
| Nome Fornecedor | ZZ2_NOMEFO | C | 40 | 0 | **Virtual** |
| Data Ocorrência | ZZ2_DATA | D | 8 | 0 | Real |
| Hora | ZZ2_HORA | C | 5 | 0 | Real |
| Produto | ZZ2_CODPRO | C | 15 | 0 | Real |
| Qtde. Conforme | ZZ2_QTDOK | N | 12 | 0 | Real |
| Qtde. Não Conforme | ZZ2_QTDNOK | N | 12 | 0 | Real |
| Valor Unitário | ZZ2_VLRUNI | N | 12 | 2 | Real |
| R$ Conforme | ZZ2_TOTOK | N | 12 | 2 | **Virtual** |
| R$ Não Conforme | ZZ2_TOTNOK | N | 12 | 2 | **Virtual** |

**Índices (SIX):**

1. `ZZ2_FILIAL + ZZ2_CONFOR + DTOS(ZZ2_DATA) + ZZ2_HORA` — chave primária
2. `ZZ2_FILIAL + ZZ2_FORNEC + ZZ2_LOJAFO + DTOS(ZZ2_DATA)` — por fornecedor e data
3. `ZZ2_FILIAL + DTOS(ZZ2_DATA)` — por data

> Nota: os campos numéricos de quantidade e valor usam o Formato (X3_PICTURE) `@E 999,999,999.99` para aceitar vários dígitos.

---

## 4. Campos virtuais

Campos virtuais não são gravados no banco: eles são **calculados na hora** de exibir.

- **ZZ1_NOMEFO / ZZ2_NOMEFO** — buscam o nome do fornecedor na SA2:
  `POSICIONE("SA2", 1, xFilial("SA2") + <FORNEC> + <LOJAFO>, "A2_NOME")`
- **ZZ2_TOTOK** = `M->ZZ2_QTDOK * M->ZZ2_VLRUNI`
- **ZZ2_TOTNOK** = `M->ZZ2_QTDNOK * M->ZZ2_VLRUNI`

---

## 5. Gatilhos (SX7)

Gatilho é uma regra que, ao preencher um campo, preenche automaticamente outro.

| Origem | Destino | Regra |
|---|---|---|
| ZZ1_FORNEC | ZZ1_NOMEFO | Traz o nome do fornecedor (SA2) |
| ZZ2_CONFOR | ZZ2_FORNEC | Traz o fornecedor do certificado (ZZ1) |
| ZZ2_CONFOR | ZZ2_LOJAFO | Traz a loja do certificado (ZZ1) |
| ZZ2_CONFOR | ZZ2_NOMEFO | Traz o nome do fornecedor (SA2) |

A **data** e a **hora** da ocorrência são preenchidas por **inicializador padrão** (X3_RELACAO), não por gatilho, porque um gatilho no próprio campo sobrescreveria o valor digitado pelo usuário:

- **ZZ2_DATA** → Inic. Padrão: `IF(INCLUI, dDataBase, M->ZZ2_DATA)`
- **ZZ2_HORA** → Inic. Padrão: `IF(INCLUI, Time(), M->ZZ2_HORA)`

Os gatilhos estão no dicionário de gatilhos (`sx7990.dbf`).

---

## 6. Validações obrigatórias (SX3 — X3_VALID)

Cada validação **bloqueia o campo** quando o valor é inválido e exibe uma **mensagem amigável**. As validações simples (faixa/data) usam `iif(<condição>, .T., (MsgAlert("mensagem"), .F.))` direto no dicionário. As checagens de **existência** (fornecedor, certificado, produto) ficariam maiores que o limite de **128 caracteres** do campo `X3_VLDUSER`; por isso a lógica delas foi movida para funções na `STTZZLIB` (`U_VldFor`, `U_VldCer`, `U_VldPro`) e o dicionário só as chama.

> **Nota de compatibilidade (Protheus 8):** o enunciado sugere `ExistCpo(...)` para checar se o registro existe. No ambiente utilizado (MP8.11), o `ExistCpo` não localizou registros válidos (retornava "não existe" para fornecedores/produtos que existiam). A verificação foi feita com `Posicione(...)`, que funciona corretamente na build e aplica **a mesma regra** (o registro precisa existir).

**Na ZZ1:**

- **ZZ1_LOJAFO** — o par fornecedor+loja deve existir na SA2 (a validação fica no campo Loja, o último da chave, para que Cod.Forn e Loja já estejam preenchidos): `U_VldFor()`
- **ZZ1_VALCER** — não pode ser anterior à data atual na inclusão: `M->ZZ1_VALCER >= dDataBase`
- **ZZ1_TOLERA** — deve estar entre 0 e 100: `M->ZZ1_TOLERA >= 0 .And. M->ZZ1_TOLERA <= 100`

**Na ZZ2:**

- **ZZ2_CONFOR** — o certificado deve existir na ZZ1: `U_VldCer()`
- **ZZ2_CODPRO** — o produto deve existir na SB1: `U_VldPro()`
- **ZZ2_DATA** — não pode ser data futura: `M->ZZ2_DATA <= dDataBase`

Além disso, a **exclusão de uma ZZ1** é bloqueada quando existem ocorrências (ZZ2) vinculadas (integridade referencial — ver seção 7.1).

---

## 7. Rotinas desenvolvidas

### 7.1 STTZZ1.PRW — mBrowse da ZZ1
- Browse com **legenda por validade do certificado**:
  - 🔴 Vermelho: `ZZ1_VALCER < dDataBase` (vencido)
  - 🟡 Amarelo: `ZZ1_VALCER <= dDataBase + 30` (vence em 30 dias)
  - 🟢 Verde: certificado ok
- Botão **"Ocorrências"** (`U_STZ1OC`): abre a ZZ2 já filtrada pelo certificado selecionado.
- **Exclusão com integridade** (`U_STZ1DEL`): não deixa excluir uma ZZ1 que tenha ocorrências (ZZ2) vinculadas. Toda a gravação está protegida por `BEGIN SEQUENCE`.

### 7.2 STTZZ2.PRW — mBrowse da ZZ2
- `U_STTZZ2()` — browse completo das ocorrências.
- `U_STTZ2F(cCodZZ1)` — versão **filtrada**, chamada pelo botão "Ocorrências" da ZZ1.
- **Legenda por tolerância**:
  - 🔴 Vermelho: % não conforme **acima** da tolerância do certificado
  - 🟢 Verde: dentro da tolerância
- `U_ZZ2NOK()` — função auxiliar da legenda que calcula o % de não conformidade da ocorrência e compara com a tolerância (ZZ1_TOLERA).

### 7.3 STTZZLIB.PRW — biblioteca de funções comuns

> **Observação importante:** o ADVPL limita o nome das *User Functions* a 10 caracteres. Por isso os nomes do enunciado foram encurtados. A tabela abaixo mostra o "de/para".

| Enunciado | Função no projeto | O que faz |
|---|---|---|
| NomeFornecedor | `U_NomeFor(cForn, cLoja)` | Nome do fornecedor (SA2) via POSICIONE |
| NomeProduto | `U_NomePro(cCodPro)` | Descrição do produto (SB1) |
| PercNaoConforme | `U_PercNC(nOk, nNok)` | Calcula o % de não conformidade (com proteção contra divisão por zero) |
| CertificadoVencendo | `U_CertVen(dValCer)` | `.T.` se o certificado vence em até 30 dias |
| GravarLogTCC | `U_LogTCC(cFuncao, oErro)` | Grava log técnico de erro em `\system\logtcc.log` |
| (validação) | `U_VldFor()` | Valida se o fornecedor+loja existe na SA2 (mensagem própria) |
| (validação) | `U_VldCer()` | Valida se o certificado (ZZ2_CONFOR) existe na ZZ1 |
| (validação) | `U_VldPro()` | Valida se o produto (ZZ2_CODPRO) existe na SB1 |

### 7.4 STTZZCLS.PRW — classe ADVPL (diferencial POO)
Classe **`ZCertificado`** que representa o certificado do fornecedor:
- `New(dValidade, nTolerancia)` — construtor
- `DiasParaVencer()` — dias até vencer
- `Vencido()` / `Vencendo()` — situação da validade
- `StatusCor()` — retorna "VERMELHO", "AMARELO" ou "VERDE"
- `DentroTolerancia(nPercNC)` — se um % está dentro da tolerância

### 7.5 STTZZTST.PRW — massa de dados de teste
Cria fornecedores, produtos, certificados e ocorrências de exemplo (incluindo casos vencido, vencendo e acima da tolerância) para testar as telas rapidamente.

---

## 8. Consultas-padrão (SXB / F3)

| Consulta | Campos exibidos |
|---|---|
| **ZZ1** (certificado) | ZZ1_CODIGO, ZZ1_NOMEFO, ZZ1_VALCER |
| **SA2** (fornecedor) | A2_COD, A2_LOJA, A2_NOME |
| **SB1** (produto) | B1_COD, B1_DESC, B1_UM |

A consulta ZZ1 é usada no campo `ZZ2_CONFOR` (X3_F3 = "ZZ1"). As consultas SA2 e SB1 são vinculadas em `ZZ1_FORNEC` e `ZZ2_CODPRO`.

---

## 9. Tratamento de erros (BEGIN SEQUENCE)

Todas as gravações diretas no banco usam o padrão:

```advpl
Local oErro   := Nil
Local bErrAnt := ErrorBlock({|e| oErro := e, Break(e)})

BEGIN SEQUENCE
    RecLock("ZZ1", .F.)
        ZZ1->(dbDelete())
    MsUnLock()
RECOVER USING oErro
    MsgAlert("Mensagem amigável ao usuário.", "Erro")
    U_LogTCC("NomeDaFuncao", oErro)     // log técnico
END SEQUENCE

ErrorBlock(bErrAnt)
```

Isso garante **mensagem amigável** ao usuário e **log técnico** em caso de falha, sem quebrar o sistema. Está aplicado em `STTZZ1.PRW` (exclusão) e em `STTZZTST.PRW`.

> Em Protheus 8 evitamos `BEGIN TRANSACTION`/`DisarmTransaction`. Como cada gravação aqui mexe em um único registro por vez, o `BEGIN SEQUENCE` já protege a operação com segurança.

---

## 10. Instalação (ambiente Protheus)

### Passo 1 — Dicionário
O dicionário está nos arquivos **.dbf** da pasta `Dados-e-Dicionario/` (SX2, SX3, SIX, SX7, SXB). Para reproduzir em outro ambiente, cadastre no **SIGACFG > Base de Dados > Dicionário (CFGX031)** as tabelas **ZZ1** e **ZZ2** conforme as seções 3 a 8 deste README:

1. Tabelas (SX2) — modo **Compartilhado**.
2. Campos (SX3) — com `X3_VALID` (validações da seção 6), `X3_F3` (consultas) e o Formato `@E 999,999,999.99` nos numéricos.
3. Índices (SIX), Gatilhos (SX7) e Consultas-padrão (SXB).
4. Atualize a estrutura para o sistema criar as tabelas físicas.

Os arquivos `zz1990.dbf`, `zz2990.dbf`, `sa2990.dbf` e `sb1990.dbf` já contêm os **dados de teste**.

### Passo 2 — Fontes
Compile no **IDE / RPO**: `STTZZLIB.PRW`, `STTZZCLS.PRW`, `STTZZ1.PRW`, `STTZZ2.PRW` e `STTZZTST.PRW`.

> Compile a `STTZZLIB` e a `STTZZCLS` **antes**, pois as outras dependem delas.

### Passo 3 — Menu
O menu está em `sigacom.xnu`. No Compras, o grupo **Controle ISO 9001** tem: **Controle de Fornecimento** (`U_STTZZ1`), **Ocorrências de Fornecedores** (`U_STTZZ2`) e **Gerar Massa Teste** (`U_STTZZTST`, utilitário).

### Passo 4 — Teste
Rode **Gerar Massa Teste** uma vez e abra **Controle de Fornecimento** para ver a legenda colorida.

---

## 11. Como testar (roteiro)

1. Abra **Controle de Fornecimento (ZZ1)** — veja as cores da legenda (vencido/vencendo/ok).
2. Selecione um certificado e clique em **Ocorrências** — a ZZ2 abre filtrada.
3. Na ZZ2, veja a linha **vermelha** (acima da tolerância).
4. Tente **excluir** um certificado que tem ocorrências — o sistema bloqueia.
5. Tente **incluir** uma ocorrência com data futura — a validação impede.
6. Tente **incluir** um certificado com tolerância 150 — a validação impede (mensagem "Tolerancia deve ser de 0 a 100!").

---

## 12. Checklist da rubrica

| Critério | Peso | Onde está |
|---|---|---|
| Dicionário (tabelas, índices, SX3) | 20% | `Dados-e-Dicionario/` (.dbf) + seções 3 a 8 |
| Rotinas funcionais (mBrowse, legendas, filtros) | 20% | `STTZZ1.PRW`, `STTZZ2.PRW` |
| Validações de dados (campo a campo, integridade) | 15% | X3_VALID (seção 6) + `U_STZ1DEL` |
| Gatilhos automáticos | 10% | `sx7990.dbf` (seção 5) |
| Tratamento de erros (BEGIN SEQUENCE) | 10% | `STTZZ1.PRW`, `STTZZTST.PRW` |
| Biblioteca de funções (STTZZLIB) | 10% | `STTZZLIB.PRW` |
| Menu configurado | 5% | `sigacom.xnu` |
| Documentação | 10% | `TCC-Documentacao.docx` + este README |

**Diferenciais (pontos extras):**

- ✅ Indentação e comentários de cabeçalho em todos os fontes
- ✅ Reaproveitamento de código (STTZZLIB, com funções `U_VldFor/U_VldCer/U_VldPro` reaproveitadas nas validações — zero duplicação)
- ✅ Validação de consistência nos campos de entrada
- ✅ Legenda da ZZ2 calculando o % de não conformidade × tolerância
- ✅ Classe ADVPL / POO (`ZCertificado` em `STTZZCLS.PRW`)
- ✅ Impede exclusão de ZZ1 com ZZ2 vinculada (integridade referencial)
