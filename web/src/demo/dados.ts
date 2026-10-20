import type {
  ArmazemDetalhe,
  CategoriaDetalhe,
  EnderecoDetalhe,
  ExtratoItem,
  ImportacaoDetalhe,
  ImportacaoLinhaDetalhe,
  EmbalagemDetalhe,
  ProdutoDetalhe,
  SaldoItem,
  StatusCadastro,
  StatusEndereco,
  UsuarioDetalhe,
} from '@/api/gerado/modelos'

/**
 * Dados de exemplo do modo demonstração. São gerados de forma determinística (sem Math.random), para as telas e os
 * GIFs ficarem iguais a cada vez.
 */

/** Mesma regra da API: completo quando todas as embalagens têm peso e as três medidas. */
export function statusDoCadastro(embalagens: EmbalagemDetalhe[]): StatusCadastro {
  return embalagens.every((e) => e.pesoKg != null && e.alturaCm != null && e.larguraCm != null && e.comprimentoCm != null)
    ? 'Completo'
    : 'Incompleto'
}

function id(prefixo: string, n: number) {
  return `${prefixo}-${String(n).padStart(4, '0')}`
}

/** Sequência pseudoaleatória fixa (LCG), para variar os dados sem mudar entre recargas. */
function sequencia(semente: number) {
  let valor = semente
  return () => {
    valor = (valor * 1_103_515_245 + 12_345) % 2_147_483_648
    return valor / 2_147_483_648
  }
}

export const categorias: CategoriaDetalhe[] = [
  { id: 'cat-alim', nome: 'Alimentos', parentId: null, caminho: 'Alimentos' },
  { id: 'cat-graos', nome: 'Grãos', parentId: 'cat-alim', caminho: 'Alimentos > Grãos' },
  { id: 'cat-bebidas', nome: 'Bebidas', parentId: null, caminho: 'Bebidas' },
  { id: 'cat-frios', nome: 'Frios', parentId: 'cat-alim', caminho: 'Alimentos > Frios' },
  { id: 'cat-limpeza', nome: 'Limpeza', parentId: null, caminho: 'Limpeza' },
]

const CATALOGO: [string, string, string, string, ProdutoDetalhe['classeArmazenagem'], number][] = [
  ['ARZ-T1-5', 'Arroz tipo 1 5kg', 'UN', 'cat-graos', 'Normal', 5.1],
  ['ARZ-INT-1', 'Arroz integral 1kg', 'UN', 'cat-graos', 'Normal', 1.02],
  ['FEI-CAR-1', 'Feijão carioca 1kg', 'UN', 'cat-graos', 'Normal', 1.02],
  ['FEI-PRE-1', 'Feijão preto 1kg', 'UN', 'cat-graos', 'Normal', 1.02],
  ['LEN-500', 'Lentilha 500g', 'UN', 'cat-graos', 'Normal', 0.51],
  ['GRA-BIC-500', 'Grão-de-bico 500g', 'UN', 'cat-graos', 'Normal', 0.51],
  ['SUC-UVA-1L', 'Suco de uva integral 1L', 'UN', 'cat-bebidas', 'Normal', 1.1],
  ['AGU-MIN-15', 'Água mineral 1,5L', 'UN', 'cat-bebidas', 'Normal', 1.55],
  ['REF-COL-2L', 'Refrigerante cola 2L', 'UN', 'cat-bebidas', 'Normal', 2.1],
  ['QUE-MUS-KG', 'Queijo muçarela', 'KG', 'cat-frios', 'Refrigerado', 1],
  ['PRE-FAT-200', 'Presunto fatiado 200g', 'UN', 'cat-frios', 'Refrigerado', 0.21],
  ['IOG-NAT-170', 'Iogurte natural 170g', 'UN', 'cat-frios', 'Refrigerado', 0.18],
  ['ALC-70-1L', 'Álcool 70% 1L', 'UN', 'cat-limpeza', 'Inflamavel', 0.9],
  ['DET-NEU-500', 'Detergente neutro 500ml', 'UN', 'cat-limpeza', 'Normal', 0.52],
  ['DES-LAV-2L', 'Desinfetante lavanda 2L', 'UN', 'cat-limpeza', 'Normal', 2.05],
  ['COP-VID-6', 'Copo de vidro (caixa com 6)', 'CX', 'cat-limpeza', 'Fragil', 1.8],
  ['MOL-TOM-340', 'Molho de tomate 340g', 'UN', 'cat-alim', 'Normal', 0.36],
  ['AZE-EXT-500', 'Azeite extravirgem 500ml', 'UN', 'cat-alim', 'Fragil', 0.95],
  ['CAF-TOR-500', 'Café torrado e moído 500g', 'UN', 'cat-alim', 'Normal', 0.52],
  ['ACU-CRI-5', 'Açúcar cristal 5kg', 'UN', 'cat-alim', 'Normal', 5.05],
  ['FAR-TRI-1', 'Farinha de trigo 1kg', 'UN', 'cat-alim', 'Normal', 1.02],
  ['MAC-ESP-500', 'Macarrão espaguete 500g', 'UN', 'cat-alim', 'Normal', 0.51],
  ['OLE-SOJ-900', 'Óleo de soja 900ml', 'UN', 'cat-alim', 'Normal', 0.92],
  ['LEI-INT-1L', 'Leite integral 1L', 'UN', 'cat-alim', 'Normal', 1.04],
]

function comStatus(produto: Omit<ProdutoDetalhe, 'statusCadastro'>): ProdutoDetalhe {
  return { ...produto, statusCadastro: statusDoCadastro(produto.embalagens) }
}

export const produtos: ProdutoDetalhe[] = CATALOGO.map(([sku, descricao, unidade, categoriaId, classe, peso], i) => comStatus({
  id: id('prod', i + 1),
  sku,
  descricao,
  unidadeBase: unidade,
  classeArmazenagem: classe,
  controlaLote: classe === 'Refrigerado',
  controlaValidade: classe === 'Refrigerado',
  ncm: '10063021',
  cest: null,
  categoriaId,
  ativo: i !== 5,
  versao: 1,
  embalagens: [
    {
      id: id('emb', i * 10 + 1),
      tipo: 'Unidade',
      fatorConversao: 1,
      unidadeBase: true,
      gtin: `789100000${String(i + 1).padStart(4, '0')}`,
      pesoKg: peso,
      alturaCm: 20,
      larguraCm: 12,
      comprimentoCm: 6,
    },
    ...(i % 3 === 0
      ? []
      : [
          {
            id: id('emb', i * 10 + 2),
            tipo: 'Caixa' as const,
            fatorConversao: 12,
            unidadeBase: false,
            gtin: `1789100000${String(i + 1).padStart(4, '0')}`,
            pesoKg: Math.round(peso * 12 * 100 + 40) / 100,
            alturaCm: 30,
            larguraCm: 40,
            comprimentoCm: 25,
          },
        ]),
  ],
}))

export const armazem: ArmazemDetalhe = {
  id: 'arm-cd1',
  codigo: 'CD1',
  nome: 'Centro de distribuição São Paulo',
  zonas: [
    { id: 'zona-seca', codigo: 'SECA', classeArmazenagem: 'Normal', enderecos: 0 },
    { id: 'zona-fria', codigo: 'FRIA', classeArmazenagem: 'Refrigerado', enderecos: 0 },
  ],
}

function gerarEnderecos(zonaId: string, ruas: string[], modulos: number, niveis: number, posicoes: number, semente: number) {
  const aleatorio = sequencia(semente)
  const lista: EnderecoDetalhe[] = []
  for (const rua of ruas) {
    for (let modulo = 1; modulo <= modulos; modulo += 1) {
      for (let nivel = 1; nivel <= niveis; nivel += 1) {
        for (let posicao = 1; posicao <= posicoes; posicao += 1) {
          const sorte = aleatorio()
          const status: StatusEndereco = sorte < 0.05 ? 'Bloqueado' : sorte < 0.6 ? 'Ocupado' : 'Livre'
          const codigo = `${rua}-${String(modulo).padStart(2, '0')}-${nivel}-${posicao}`
          lista.push({
            id: `end-${codigo}`,
            armazemId: armazem.id,
            zonaId,
            codigo,
            rua,
            modulo,
            nivel,
            posicao,
            capacidadePesoKg: nivel === 1 ? 1500 : 1000,
            alturaCm: nivel === 1 ? 180 : 150,
            larguraCm: 120,
            profundidadeCm: 100,
            distanciaExpedicao: 5 + modulo * 2,
            status,
            motivoBloqueio: status === 'Bloqueado' ? 'Longarina avariada' : null,
            bloqueadoEm: status === 'Bloqueado' ? '2026-10-10T09:00:00Z' : null,
            bloqueadoPor: status === 'Bloqueado' ? 'usr-0001' : null,
          })
        }
      }
    }
  }

  return lista
}

export const enderecos: EnderecoDetalhe[] = [
  ...gerarEnderecos('zona-seca', ['A', 'B', 'C'], 8, 4, 2, 7),
  ...gerarEnderecos('zona-fria', ['F'], 6, 3, 1, 11),
]

for (const zona of armazem.zonas) {
  zona.enderecos = enderecos.filter((e) => e.zonaId === zona.id).length
}

const aleatorioSaldos = sequencia(23)

export const saldos: SaldoItem[] = enderecos
  .filter((e) => e.status === 'Ocupado')
  .map((endereco, i) => {
    const candidatos = produtos.filter((p) =>
      endereco.zonaId === 'zona-fria' ? p.classeArmazenagem === 'Refrigerado' : p.classeArmazenagem !== 'Refrigerado',
    )
    const produto = candidatos[i % candidatos.length]
    const quantidade = 12 * (1 + Math.floor(aleatorioSaldos() * 20))
    const reservada = aleatorioSaldos() < 0.2 ? 12 : 0
    return {
      enderecoId: endereco.id,
      enderecoCodigo: endereco.codigo,
      armazemId: armazem.id,
      zonaId: endereco.zonaId,
      produtoId: produto.id,
      sku: produto.sku,
      descricao: produto.descricao,
      unidadeBase: produto.unidadeBase,
      loteId: produto.controlaLote ? `lote-${i}` : null,
      loteNumero: produto.controlaLote ? `L26${String(100 + i)}` : null,
      validade: produto.controlaValidade ? `2026-${String(11 + (i % 2)).padStart(2, '0')}-${String(5 + (i % 20)).padStart(2, '0')}` : null,
      quantidade,
      quantidadeReservada: reservada,
      quantidadeDisponivel: quantidade - reservada,
    }
  })

export const movimentacoes: ExtratoItem[] = saldos.slice(0, 60).flatMap((saldo, i) => {
  const dia = new Date(Date.UTC(2026, 9, 18 - (i % 15), 8 + (i % 9), (i * 7) % 60))
  const entrada: ExtratoItem = {
    id: id('mov', i * 2 + 1),
    tipo: 'Entrada',
    ocorridoEm: dia.toISOString(),
    recebidoEm: dia.toISOString(),
    produtoId: saldo.produtoId,
    sku: saldo.sku,
    loteNumero: saldo.loteNumero,
    enderecoOrigemCodigo: null,
    enderecoDestinoCodigo: saldo.enderecoCodigo,
    quantidade: saldo.quantidade + 12,
    documentoReferencia: `NF ${String(4500 + i)}`,
    observacao: null,
    usuarioId: 'usr-0002',
  }
  const saida: ExtratoItem = {
    ...entrada,
    id: id('mov', i * 2 + 2),
    tipo: i % 5 === 0 ? 'Transferencia' : 'Saida',
    ocorridoEm: new Date(dia.getTime() + 3 * 3_600_000).toISOString(),
    enderecoOrigemCodigo: saldo.enderecoCodigo,
    enderecoDestinoCodigo: i % 5 === 0 ? 'A-01-1-1' : null,
    quantidade: 12,
    documentoReferencia: i % 5 === 0 ? null : `PED ${String(9000 + i)}`,
    usuarioId: 'usr-0003',
  }
  return [saida, entrada]
}).sort((a, b) => b.ocorridoEm.localeCompare(a.ocorridoEm))

export const usuarios: UsuarioDetalhe[] = [
  ['Ana Souza', 'admin@stowise.dev', ['Admin']],
  ['Bruno Lima', 'gestor@stowise.dev', ['Gestor']],
  ['Carla Dias', 'operador@stowise.dev', ['Operador']],
  ['Diego Rocha', 'diego@stowise.dev', ['Operador']],
  ['Elisa Martins', 'elisa@stowise.dev', ['Gestor', 'Operador']],
  ['Fábio Nunes', 'fabio@stowise.dev', ['Operador']],
].map(([nome, email, perfis], i) => ({
  id: id('usr', i + 1),
  nome: nome as string,
  email: email as string,
  perfis: perfis as string[],
  ativo: i !== 5,
  bloqueado: i === 3,
  criadoEm: `2026-09-${String(10 + i).padStart(2, '0')}T12:00:00Z`,
}))

const LAYOUT: ImportacaoDetalhe['layout'] = {
  formato: 'Delimitado',
  encoding: 'UTF-8',
  delimitador: ';',
  separadorDecimal: ',',
  temCabecalho: true,
  colunas: ['Cod', 'Descrição', 'Unid', 'EAN', 'Peso (g)', 'Categoria'].map((nome, indice) => ({ indice, nome })),
}

const AMOSTRA = [
  ['P-1001', 'Biscoito maisena 400g', 'UND', '7891000100103', '410', 'Alimentos'],
  ['P-1002', 'Bolacha recheada 140g', 'UND', '7891000100110', '145', 'Alimentos'],
  ['P-1003', 'Chá mate 250g', 'PCT', '7891000100127', '260', 'Bebidas'],
  ['P-1004', 'Sabão em pó 1kg', 'CX', '', '1020', 'Limpeza'],
  ['P-1005', 'Esponja multiuso (3 un)', 'PCT', '7891000100141', '45', 'Limpeza'],
]

function importacao(n: number, extra: Partial<ImportacaoDetalhe>): ImportacaoDetalhe {
  return {
    id: id('imp', n),
    tipo: 'Produtos',
    status: 'Recebido',
    nomeArquivo: `produtos-fornecedor-${n}.csv`,
    hashArquivo: `hash-${n}`,
    tamanhoBytes: 18_432,
    layout: LAYOUT,
    amostra: AMOSTRA,
    totalLinhas: 240,
    usuarioId: 'usr-0002',
    iniciadoEm: `2026-10-${String(10 + n).padStart(2, '0')}T14:00:00Z`,
    concluidoEm: null,
    fingerprint: `fp-${n}`,
    templateId: null,
    mapeamento: null,
    mapeamentoConfirmadoPor: null,
    mapeamentoConfirmadoEm: null,
    linhasValidas: 0,
    linhasComErro: 0,
    linhasPossivelDuplicata: 0,
    linhasProcessadas: 0,
    produtosCriados: 0,
    produtosAtualizados: 0,
    motivoFalha: null,
    regras: null,
    sugestaoIa: null,
    mapeamentoSugeridoPorIa: false,
    motivoSemSugestao: null,
    versao: 1,
    ...extra,
  } as ImportacaoDetalhe
}

const MAPEAMENTO = [
  { campo: 'sku', coluna: 0 },
  { campo: 'descricao', coluna: 1 },
  { campo: 'unidadeBase', coluna: 2 },
  { campo: 'gtin', coluna: 3 },
  { campo: 'pesoKg', coluna: 4 },
  { campo: 'categoria', coluna: 5 },
]

export const importacoes: ImportacaoDetalhe[] = [
  importacao(1, {
    status: 'Concluido',
    mapeamento: MAPEAMENTO,
    linhasProcessadas: 240,
    linhasValidas: 236,
    linhasComErro: 4,
    produtosCriados: 210,
    produtosAtualizados: 26,
    concluidoEm: '2026-10-11T14:06:00Z',
  }),
  importacao(2, {
    status: 'AguardandoRevisao',
    mapeamento: MAPEAMENTO,
    linhasProcessadas: 240,
    linhasValidas: 229,
    linhasComErro: 9,
    linhasPossivelDuplicata: 2,
  }),
  importacao(3, {
    status: 'AguardandoConfirmacao',
    mapeamentoSugeridoPorIa: true,
    sugestaoIa: {
      colunas: [
        { campo: 'sku', coluna: 0, confianca: 0.98 },
        { campo: 'descricao', coluna: 1, confianca: 0.97 },
        { campo: 'unidadeBase', coluna: 2, confianca: 0.88 },
        { campo: 'gtin', coluna: 3, confianca: 0.93 },
        { campo: 'pesoKg', coluna: 4, confianca: 0.52 },
        { campo: 'categoria', coluna: 5, confianca: 0.9 },
      ],
      regras: {
        separadorDecimal: ',',
        unidades: [
          { origem: 'UND', destino: 'UN' },
          { origem: 'PCT', destino: 'PC' },
        ],
        valoresVerdadeiros: ['S', 'Sim'],
        valoresFalsos: ['N', 'Não'],
      },
      observacao: 'A coluna "Peso (g)" parece estar em gramas; confira a conversão para kg.',
      chamadaIaId: 'ia-0001',
    },
  }),
]

export const linhasImportacao: ImportacaoLinhaDetalhe[] = Array.from({ length: 40 }, (_, i) => {
  const erro = i % 9 === 4
  const duplicata = i === 7 || i === 21
  return {
    id: id('lin', i + 1),
    numeroLinha: i + 2,
    dadosBrutos: AMOSTRA[i % AMOSTRA.length],
    dadosNormalizados: { sku: `P-${1001 + i}`, descricao: AMOSTRA[i % AMOSTRA.length][1] },
    status: erro ? 'Erro' : duplicata ? 'PossivelDuplicata' : 'Valida',
    acao: erro ? 'Ignorar' : i % 6 === 0 ? 'Atualizar' : 'Criar',
    produtoCorrespondenteId: i % 6 === 0 && !erro ? produtos[i % produtos.length].id : null,
    similaridade: duplicata ? 0.91 : null,
    erros: erro
      ? [
          { campo: 'pesoKg', mensagem: 'Peso inválido: "1.020,5,0".' },
          { campo: 'unidadeBase', mensagem: 'Unidade "CXA" não está no de-para.' },
        ]
      : [],
    efetivadaEm: null,
  }
})
