# Exercício 3 — Fluxograma

**Problema:** Uma loja dá desconto de 10% para compras acima de R$ 100. Leia o valor da compra e mostre o valor final a pagar.

## Fluxograma (Mermaid)

```mermaid
flowchart TD
    A([Início]) --> B[/Leia valor/]
    B --> C{valor > 100?}
    C -- Sim --> D[final ← valor - valor * 0.10]
    C -- Não --> E[final ← valor]
    D --> F[/Escreva final/]
    E --> F
    F --> G([Fim])
```


## Fluxograma em ASCII (alternativa para papel)

```
        ( Início )
            |
     /-----------------/
    / Leia valor      /
   /-----------------/
            |
      < valor > 100? >
        /         \
      Sim          Não
       |            |
 [final ←      [final ← valor]
  valor - 10%]      |
       \           /
        \         /
     /-----------------/
    / Escreva final   /
   /-----------------/
            |
         ( Fim )
```

O fluxograma tem **início/fim** (ovais), **entrada** (Leia valor), um **losango de decisão** (valor > 100?) com os dois caminhos **Sim** e **Não**, um **processo** de cálculo e a **saída** (Escreva final).