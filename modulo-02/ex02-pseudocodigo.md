# Exercício 2 — Pseudocódigo

## a. Área de um retângulo (base × altura)

```
Início
    Leia base
    Leia altura
    area ← base * altura
    Escreva "A área é: ", area
Fim
```

## b. Verificar se um número é par ou ímpar

```
Início
    Leia numero
    resto ← numero mod 2       // mod = resto da divisão
    Se resto = 0 Então
        Escreva "Par"
    Senão
        Escreva "Ímpar"
Fim
```

## c. Encontrar o maior entre três números

```
Início
    Leia a
    Leia b
    Leia c
    maior ← a
    Se b > maior Então
        maior ← b
    Se c > maior Então
        maior ← c
    Escreva "O maior é: ", maior
Fim
```

Cada algoritmo tem **entrada** (Leia), **processamento** (cálculo/decisão) e **saída** (Escreva), sem ambiguidade.