# Exercício 4 — Refinamento sucessivo

**Problema:** Um sistema de caixa de supermercado deve registrar os itens de uma compra, calcular o subtotal, aplicar desconto se o cliente tiver cartão fidelidade (5%) e mostrar o total a pagar.

## Nível 1 — Visão geral

1. Registrar os itens da compra
2. Calcular o subtotal
3. Aplicar desconto de fidelidade (se houver cartão)
4. Mostrar o total a pagar

## Nível 2 — Detalhamento de cada passo

### 1. Registrar os itens da compra
- Iniciar a lista de itens vazia
- Para cada produto passado no caixa:
  - Ler o código/nome e o preço do produto
  - Ler a quantidade
  - Guardar o item (preço × quantidade) na lista
- Encerrar quando não houver mais produtos

### 2. Calcular o subtotal
- Iniciar `subtotal ← 0`
- Para cada item da lista:
  - `subtotal ← subtotal + (preço × quantidade)`

### 3. Aplicar desconto de fidelidade
- Perguntar se o cliente tem cartão fidelidade
- Se **tiver**:
  - `desconto ← subtotal × 0,05`
  - `total ← subtotal - desconto`
- Se **não tiver**:
  - `total ← subtotal`

### 4. Mostrar o total a pagar
- Escrever o subtotal
- Escrever o desconto aplicado (se houve)
- Escrever o total a pagar

Do geral (Nível 1) para o detalhe (Nível 2): cada passo grande foi quebrado em sub-passos executáveis, mostrando a técnica do refinamento sucessivo.