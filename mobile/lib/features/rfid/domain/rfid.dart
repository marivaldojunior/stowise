import 'dart:async';
import 'dart:collection';

/// Etiquetas RFID em SGTIN-96 (ADR-0010): o RFID conta unidades da embalagem do GTIN, sem rastrear cada unidade.

final _epcHex = RegExp(r'^[0-9A-F]{24}$');

/// EPC de 96 bits em hexadecimal maiúsculo, ou nulo quando o valor não é um EPC de 96 bits.
String? normalizarEpc(String valor) {
  final epc = valor.trim().toUpperCase();
  return _epcHex.hasMatch(epc) ? epc : null;
}

/// Total lido de uma embalagem, como a API resolve em POST /rfid/leituras.
class ContagemPorEmbalagem {
  const ContagemPorEmbalagem({
    required this.produtoId,
    required this.sku,
    required this.descricao,
    required this.embalagemId,
    required this.embalagem,
    required this.unidadeBase,
    required this.etiquetas,
    required this.quantidadeBase,
  });

  final String produtoId;
  final String sku;
  final String descricao;
  final String embalagemId;

  /// Rótulo da embalagem (Unidade, Caixa, Palete).
  final String embalagem;
  final String unidadeBase;

  /// EPCs distintos lidos desta embalagem.
  final int etiquetas;

  /// Etiquetas × fator da embalagem, na unidade base.
  final double quantidadeBase;
}

class ResultadoLeituraRfid {
  const ResultadoLeituraRfid({required this.contagens, required this.naoReconhecidas});

  final List<ContagemPorEmbalagem> contagens;

  /// EPCs que não são SGTIN-96 ou cujo GTIN não está no catálogo.
  final int naoReconhecidas;
}

/// EPC gerado pela API para gravar numa etiqueta, com série única.
class EtiquetaParaGravar {
  const EtiquetaParaGravar({required this.epc, required this.epcUri, required this.serie});

  /// Hexadecimal (24 caracteres), o valor gravado no banco EPC da etiqueta.
  final String epc;

  /// URI de identidade pura (urn:epc:id:sgtin:...), para mostrar e conferir.
  final String epcUri;
  final int serie;
}

class FalhaRfid implements Exception {
  const FalhaRfid(this.mensagem, {this.campos = const {}, this.semConexao = false});

  final String mensagem;

  /// Erros por campo da API (ex.: quantidade).
  final Map<String, String> campos;
  final bool semConexao;

  @override
  String toString() => mensagem;
}

/// Leitor RFID do aparelho. Cada fabricante (Zebra, Honeywell, Chainway) entra como um plugin nativo que implementa
/// esta porta; os testes usam um leitor falso.
abstract interface class LeitorRfid {
  /// Falso quando o aparelho não tem leitor RFID: a tela esconde as ações de RFID.
  bool get disponivel;

  /// EPCs lidos em hexadecimal. Na leitura em massa, a mesma etiqueta chega muitas vezes.
  Stream<String> get leituras;

  Future<void> iniciarLeitura();

  Future<void> pararLeitura();

  /// Grava o EPC na etiqueta mais próxima do leitor e confere a gravação.
  Future<void> gravar(String epc);
}

/// Padrão do app: sem plugin de fabricante, não há leitor RFID.
class LeitorRfidIndisponivel implements LeitorRfid {
  const LeitorRfidIndisponivel();

  static const _falha = FalhaRfid('Este aparelho não tem leitor RFID.');

  @override
  bool get disponivel => false;

  @override
  Stream<String> get leituras => const Stream.empty();

  @override
  Future<void> iniciarLeitura() => Future.error(_falha);

  @override
  Future<void> pararLeitura() async {}

  @override
  Future<void> gravar(String epc) => Future.error(_falha);
}

/// Junta os EPCs de uma leitura em massa: ignora repetições e valores que não são EPC de 96 bits.
class ColetaRfid {
  ColetaRfid(this._leitor);

  final LeitorRfid _leitor;
  final _epcs = <String>{};
  StreamSubscription<String>? _assinatura;

  /// EPCs distintos, na ordem da primeira leitura.
  Set<String> get epcs => UnmodifiableSetView(_epcs);

  bool get lendo => _assinatura != null;

  Future<void> iniciar() async {
    _assinatura ??= _leitor.leituras.listen(_adicionar);
    try {
      await _leitor.iniciarLeitura();
    } on Object {
      await _cancelar();
      rethrow;
    }
  }

  Future<void> parar() async {
    await _leitor.pararLeitura();
    await _cancelar();
  }

  void limpar() => _epcs.clear();

  void _adicionar(String valor) {
    if (normalizarEpc(valor) case final epc?) {
      _epcs.add(epc);
    }
  }

  Future<void> _cancelar() async {
    await _assinatura?.cancel();
    _assinatura = null;
  }
}
