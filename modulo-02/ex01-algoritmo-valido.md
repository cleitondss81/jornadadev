# Exercício 1 — Isto é um algoritmo válido?

Requisitos de um bom algoritmo: **finito** (termina), **ordenado** (passos na sequência certa) e **sem ambiguidade** (uma única interpretação).

## a. "Some dois números."
**Válido (com ressalva).** É finito, ordenado e a operação é clara. O único ponto fraco é que não especifica *quais* números nem de onde eles vêm (entrada). Como instrução isolada é aceitável, mas o ideal seria: "Leia dois números e mostre a soma".

## b. "Leia um número. Se for positivo, mostre 'positivo'. Senão, mostre 'negativo'."
**Válido.** Tem entrada (Leia), decisão sem ambiguidade (Se positivo / Senão) e saída definida. É finito e ordenado. Detalhe: o zero cairia em "negativo" pela regra do "Senão", mas para o objetivo do exercício está correto.

## c. "Fique repetindo até acabar."
**Inválido.** Fere o requisito **finito** e é **ambíguo**: não diz o que repetir, nem o que significa "acabar". Sem uma condição de parada clara, pode repetir para sempre.

## d. "Pegue um ingrediente qualquer e cozinhe."
**Inválido.** É **ambíguo**: "um ingrediente qualquer" e "cozinhe" não têm interpretação única (qual ingrediente? como cozinhar? por quanto tempo?). Falta precisão para que qualquer pessoa execute e chegue ao mesmo resultado.