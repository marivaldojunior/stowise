class Armazem {
  const Armazem({required this.id, required this.codigo, required this.nome});

  final String id;
  final String codigo;
  final String nome;
}

/// Produto encontrado pelo código lido (SKU ou GTIN). O GTIN de uma caixa traz a embalagem da caixa: a quantidade
/// informada é em caixas, e a API converte para a unidade base pelo fator.
class ProdutoLido {
  const ProdutoLido({
    required this.id,
    required this.sku,
    required this.descricao,
    required this.unidadeBase,
    required this.controlaLote,
    required this.controlaValidade,
    required this.embalagemId,
    required this.embalagem,
    required this.fator,
  });

  final String id;
  final String sku;
  final String descricao;
  final String unidadeBase;
  final bool controlaLote;
  final bool controlaValidade;
  final String embalagemId;

  /// Unidade, Caixa ou Palete.
  final String embalagem;

  /// Quantas unidades base cabem na embalagem lida (1 na unidade).
  final double fator;

  bool get embalagemBase => fator == 1;

  /// "UN" na unidade base; "Caixa (12 UN)" numa embalagem maior.
  String get unidadeDaQuantidade => embalagemBase ? unidadeBase : '$embalagem (${_numero(fator)} $unidadeBase)';
}

class EnderecoLido {
  const EnderecoLido({required this.id, required this.codigo, required this.bloqueado});

  final String id;
  final String codigo;
  final bool bloqueado;
}

enum TipoMovimento {
  entrada('Entrada', 'Registrar entrada'),
  saida('Saída', 'Registrar saída'),
  transferencia('Transferência', 'Registrar transferência');

  const TipoMovimento(this.rotulo, this.acao);

  final String rotulo;
  final String acao;
}

/// Movimentação pronta para enviar. A [chave] de idempotência vem do aparelho: repetir o envio depois de uma falha
/// de rede não grava duas vezes (ADR-0006).
class Movimento {
  const Movimento({
    required this.tipo,
    required this.produto,
    required this.quantidade,
    required this.chave,
    required this.dispositivoId,
    this.origem,
    this.destino,
    this.loteNumero,
    this.loteValidade,
    this.documento,
  });

  final TipoMovimento tipo;
  final ProdutoLido produto;
  final double quantidade;
  final String chave;
  final String dispositivoId;
  final EnderecoLido? origem;
  final EnderecoLido? destino;
  final String? loteNumero;
  final DateTime? loteValidade;
  final String? documento;
}

class MovimentoRegistrado {
  const MovimentoRegistrado({required this.id, required this.quantidadeBase, required this.repetido});

  final String id;

  /// Quantidade gravada na unidade base (já convertida pelo fator).
  final double quantidadeBase;

  /// A API já tinha esta operação (mesma chave): nada foi gravado de novo.
  final bool repetido;
}

/// Saldo de um produto num endereço (e lote).
class SaldoLinha {
  const SaldoLinha({
    required this.enderecoCodigo,
    required this.sku,
    required this.descricao,
    required this.unidade,
    required this.quantidade,
    required this.reservada,
    required this.disponivel,
    this.lote,
    this.validade,
  });

  final String enderecoCodigo;
  final String sku;
  final String descricao;
  final String unidade;
  final String? lote;
  final DateTime? validade;
  final double quantidade;
  final double reservada;
  final double disponivel;
}

class LoteResumo {
  const LoteResumo({required this.quantidade, this.numero, this.validade});

  final String? numero;
  final DateTime? validade;
  final double quantidade;
}

/// Totais do produto em todos os endereços.
class ResumoProduto {
  const ResumoProduto({
    required this.sku,
    required this.descricao,
    required this.unidade,
    required this.quantidade,
    required this.reservada,
    required this.disponivel,
    required this.enderecos,
    required this.lotes,
  });

  final String sku;
  final String descricao;
  final String unidade;
  final double quantidade;
  final double reservada;
  final double disponivel;
  final int enderecos;
  final List<LoteResumo> lotes;
}

/// Falha de uma operação de estoque, pronta para a tela.
class FalhaEstoque implements Exception {
  const FalhaEstoque(this.mensagem, {this.campos = const {}, this.semConexao = false, this.naoEncontrado = false});

  final String mensagem;

  /// Erros por campo da API (ex.: quantidade, lote.numero).
  final Map<String, String> campos;
  final bool semConexao;
  final bool naoEncontrado;

  @override
  String toString() => mensagem;
}

String _numero(double valor) => valor == valor.roundToDouble() ? valor.toInt().toString() : valor.toString();

/// Número para a tela, sem casas decimais quando é inteiro e com vírgula decimal.
String formatarQuantidade(double valor) => _numero(valor).replaceAll('.', ',');
