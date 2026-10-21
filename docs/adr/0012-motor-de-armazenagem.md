# 0012 — Motor de armazenagem por pontuação de regras, sem LLM, com restrições que não se desligam

- **Status:** Aceito
- **Data:** 2026-10-21

## Contexto

Depois da conferência, cada item do recebimento precisa de um endereço (SPEC, 2.3). O SPEC pede um motor de pontuação com regras configuráveis (capacidade, zona, curva ABC, FEFO e consolidação), a explicação de cada sugestão e nenhum LLM na decisão (SPEC, decisões 6 e 7). Forças:

1. Algumas regras são de segurança: um inflamável fora da zona de inflamáveis ou uma estante acima do peso não são "piores", são proibidos.
2. As outras regras são preferências que competem entre si (ex.: a curva ABC quer o produto C longe da expedição; a consolidação quer juntar o produto onde ele já está).
3. O gestor ajusta os pesos pelo painel (SPEC, 2.4), e a sugestão gravada na tarefa precisa continuar explicável depois que os pesos mudam.
4. A NF-e não traz peso nem medidas. Muitos produtos entram como Incompletos (SPEC, 2.1), e o motor não pode parar por isso.
5. O motor roda a cada pedido de sugestão no app, então ele tem de ser rápido e determinístico.

## Decisão

1. **Regra como estratégia.** Cada regra implementa `IRegraArmazenagem` (Domain/Armazenagem): um `Codigo` (a chave da `RegraArmazenagem` no banco), os parâmetros que aceita, com os valores padrão, e um `Avaliar` que recebe **todos** os candidatos de uma vez. Regras como a curva ABC comparam os endereços entre si. Cada avaliação traz uma nota de 0 a 1 (ou nula, quando a regra não se aplica) e uma explicação em português.
2. **Restrição × preferência.** Uma regra restritiva (zona e capacidade) recusa endereços, e a recusa vale **mesmo com a regra inativa**. O peso e o estado só mudam a pontuação. O motor aplica as restrições primeiro e compara as preferências só entre os endereços que sobraram.
3. **Pontuação.** A nota final vai de 0 a 100. Ela é a média das notas das regras ativas, com peso maior que 0 e aplicáveis, ponderada pelos pesos. Uma regra que não se aplica (ex.: FEFO para um item sem validade) sai da média e não puxa a nota para baixo. O empate é decidido pela menor distância até a expedição e depois pelo código do endereço, para a mesma entrada dar sempre a mesma ordem.
4. **As cinco regras.**
   - **Zona** (restritiva): a classe da zona é a do produto. Peso inicial 0, porque ela só restringe.
   - **Capacidade** (restritiva): o peso e o volume depois de guardar cabem até `ocupacaoMaxima`% (padrão 100). A nota é a ocupação depois de guardar, para preferir o endereço mais justo. Sem peso e sem medidas no cadastro, a regra não se aplica e a explicação manda conferir.
   - **Curva ABC**: A perto da expedição, B no meio e C longe, pela distância comparada entre os candidatos. Produto novo entra como C até o job de recálculo.
   - **FEFO**: não misturar validades diferentes do mesmo produto num endereço (tolerância em `toleranciaDias`). Isso evita que o lote que vence antes fique escondido.
   - **Consolidação**: mesmo lote (100), mesmo produto em outro lote (70), endereço vazio (40), só outros produtos (0), todos parametrizáveis.
5. **Medidas da carga.** O peso e o volume por unidade base vêm da maior embalagem que tem o dado (`MedidasUnitarias`). O estoque que já está no endereço usa a mesma conta.
6. **Snapshot.** Cada sugestão leva a nota, o peso, o estado e a explicação de todas as regras (`NotaRegra`). A tarefa de armazenagem grava essa lista em `PontuacaoJson`, para explicar a sugestão depois que os pesos mudam.
7. **Configuração.** As cinco linhas de `regras_armazenagem` entram pela migration, com os parâmetros padrão. A Gestão muda o peso (0 a 100), o estado e os parâmetros com a versão lida (`xmin`, 409 se mudou). Um parâmetro que a regra não conhece é recusado (422).

## Consequências

- Uma regra nova é uma classe nova, uma linha na migration e um teste. O motor e os endpoints não mudam.
- A sugestão é explicável e reproduzível: com os mesmos dados e os mesmos pesos, a ordem é a mesma.
- Desligar uma regra restritiva não abre brecha de segurança. Para guardar um produto fora da sua zona, mude a classe da zona ou do produto.
- Com o cadastro incompleto, a capacidade não é verificada. A explicação avisa o operador, e a fila de cadastros incompletos continua sendo o caminho para corrigir.
- O motor carrega todos os endereços não bloqueados do armazém a cada pedido. Isso serve para a escala da demonstração (centenas de endereços). Para dezenas de milhares, filtre antes por zona e por capacidade no SQL.
- A curva ABC usa a distância relativa entre os candidatos, não um valor absoluto. Num armazém com um só endereço livre, a regra dá nota máxima.

## Alternativas consideradas

- **LLM para escolher o endereço** — o SPEC proíbe. Também seria lento, caro, não determinístico e difícil de explicar.
- **Otimização global (programação linear) de todos os itens do recebimento** — dá um resultado melhor para muitos itens juntos, mas é mais difícil de explicar ao operador e de ajustar por peso. O motor por item com snapshot atende ao SPEC. A otimização fica para quando houver dados de uso.
- **Restrições como regras de peso alto** — um peso grande não impede um endereço proibido se as outras notas forem altas. A restrição precisa recusar o endereço.
- **Filtro por zona só no SQL, sem a regra de zona** — é mais rápido, mas o motivo da recusa some da resposta e a garantia sai do domínio.
