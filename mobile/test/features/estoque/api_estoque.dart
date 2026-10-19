import 'package:dio/dio.dart';

import '../../api_falsa.dart';

/// Produto como a API devolve em GET /produtos/codigo/{codigo}: a embalagem lida vem em embalagemId.
Map<String, Object?> produtoPorCodigo({
  required String id,
  required String sku,
  required String descricao,
  String embalagemId = 'emb-un',
  bool controlaLote = false,
  bool controlaValidade = false,
}) => {
  'embalagemId': embalagemId,
  'produto': {
    'id': id,
    'sku': sku,
    'descricao': descricao,
    'unidadeBase': 'UN',
    'classeArmazenagem': 'Normal',
    'controlaLote': controlaLote,
    'controlaValidade': controlaValidade,
    'ncm': null,
    'cest': null,
    'categoriaId': null,
    'ativo': true,
    'versao': 1,
    'embalagens': [
      {
        'id': 'emb-un',
        'tipo': 'Unidade',
        'fatorConversao': 1,
        'unidadeBase': true,
        'gtin': '7891000000017',
        'pesoKg': 5.1,
        'alturaCm': null,
        'larguraCm': null,
        'comprimentoCm': null,
      },
      {
        'id': 'emb-cx',
        'tipo': 'Caixa',
        'fatorConversao': 12,
        'unidadeBase': false,
        'gtin': '17891000000014',
        'pesoKg': 62,
        'alturaCm': null,
        'larguraCm': null,
        'comprimentoCm': null,
      },
    ],
  },
};

Map<String, Object?> endereco(String codigo, {String status = 'Livre'}) => {
  'id': 'end-$codigo',
  'armazemId': 'arm-1',
  'zonaId': 'z-1',
  'codigo': codigo,
  'rua': 'A',
  'modulo': 1,
  'nivel': 1,
  'posicao': 1,
  'capacidadePesoKg': 1000,
  'alturaCm': 150,
  'larguraCm': 120,
  'profundidadeCm': 100,
  'distanciaExpedicao': 10,
  'status': status,
  'motivoBloqueio': null,
  'bloqueadoEm': null,
  'bloqueadoPor': null,
};

Map<String, Object?> movimentacao(String tipo, double quantidade) => {
  'id': 'mov-1',
  'tipo': tipo,
  'produtoId': 'p-arroz',
  'loteId': null,
  'loteNumero': null,
  'enderecoOrigemId': null,
  'enderecoDestinoId': null,
  'quantidade': quantidade,
  'documentoReferencia': null,
  'observacao': null,
  'usuarioId': 'u-1',
  'dispositivoId': null,
  'ocorridoEm': DateTime.now().toUtc().toIso8601String(),
  'recebidoEm': DateTime.now().toUtc().toIso8601String(),
  'idempotencyKey': null,
};

/// API do estoque em memória: sessão de Operador, um ou mais armazéns, produtos por SKU/GTIN e endereços por código.
/// [movimentar] responde aos POST de movimentação (padrão: 201 com a quantidade na unidade base).
ApiFalsa apiDeEstoque({
  List<Map<String, Object?>> armazens = const [
    {'id': 'arm-1', 'codigo': 'CD1', 'nome': 'Centro', 'zonas': 1, 'enderecos': 10},
  ],
  Responder? movimentar,
  Map<String, Map<String, Object?>>? produtos,
}) {
  final catalogo =
      produtos ??
      {
        'ARZ-T1-5': produtoPorCodigo(id: 'p-arroz', sku: 'ARZ-T1-5', descricao: 'Arroz tipo 1 5kg'),
        '17891000000014': produtoPorCodigo(
          id: 'p-arroz',
          sku: 'ARZ-T1-5',
          descricao: 'Arroz tipo 1 5kg',
          embalagemId: 'emb-cx',
        ),
        'QUEIJO': produtoPorCodigo(
          id: 'p-queijo',
          sku: 'QUE-MUS-KG',
          descricao: 'Queijo muçarela',
          controlaLote: true,
          controlaValidade: true,
        ),
      };
  return ApiFalsa((r) {
    final caminho = r.caminho;
    if (caminho == '/api/v1/auth/refresh') {
      return json(sessaoJson());
    }

    if (caminho == '/api/v1/armazens') {
      return json(armazens);
    }

    if (caminho.startsWith('/api/v1/produtos/codigo/')) {
      final codigo = Uri.decodeComponent(caminho.split('/').last);
      final produto = catalogo[codigo];
      return produto == null ? problema(404, 'Nenhum produto com o SKU ou GTIN $codigo.') : json(produto);
    }

    if (caminho.startsWith('/api/v1/armazens/arm-1/enderecos/codigo/')) {
      final codigo = Uri.decodeComponent(caminho.split('/').last);
      return codigo.startsWith('X')
          ? problema(404, 'Endereço $codigo não encontrado.')
          : json(endereco(codigo, status: codigo.startsWith('B') ? 'Bloqueado' : 'Livre'));
    }

    if (caminho == '/api/v1/saldos/produtos/p-queijo') {
      return json({
        'produtoId': 'p-queijo',
        'sku': 'QUE-MUS-KG',
        'descricao': 'Queijo muçarela',
        'unidadeBase': 'KG',
        'quantidade': 48,
        'quantidadeReservada': 6,
        'quantidadeDisponivel': 42,
        'enderecos': 2,
        'lotes': [
          {'loteId': 'l1', 'numero': 'L26100', 'validade': '2026-11-20', 'quantidade': 30, 'quantidadeReservada': 6},
          {'loteId': 'l2', 'numero': 'L26101', 'validade': '2026-12-05', 'quantidade': 18, 'quantidadeReservada': 0},
        ],
      });
    }

    if (caminho.startsWith('/api/v1/saldos')) {
      final porEndereco = r.query['enderecoId'] != null;
      final vazio = (r.query['enderecoId'] ?? '').toString().contains('VAZIO');
      return json({
        'itens': vazio
            ? <Object>[]
            : [
                saldoItem('F-01-1-1', 'L26100', '2026-11-20', 30, 6),
                if (!porEndereco) saldoItem('F-02-1-1', 'L26101', '2026-12-05', 18, 0),
              ],
        'pagina': 1,
        'tamanhoPagina': 100,
        'total': vazio ? 0 : (porEndereco ? 1 : 2),
      });
    }

    if (caminho.startsWith('/api/v1/movimentacoes/')) {
      if (movimentar != null) {
        return movimentar(r);
      }

      final corpo = r.corpo! as Map<String, dynamic>;
      final fator = corpo['embalagemId'] == 'emb-cx' ? 12 : 1;
      return json(movimentacao('Entrada', (corpo['quantidade'] as num).toDouble() * fator), status: 201);
    }

    return problema(404, 'Não encontrado');
  });
}

Map<String, Object?> saldoItem(String endereco, String lote, String validade, double quantidade, double reservada) => {
  'enderecoId': 'end-$endereco',
  'enderecoCodigo': endereco,
  'armazemId': 'arm-1',
  'zonaId': 'z-fria',
  'produtoId': 'p-queijo',
  'sku': 'QUE-MUS-KG',
  'descricao': 'Queijo muçarela',
  'unidadeBase': 'KG',
  'loteId': 'lote-$lote',
  'loteNumero': lote,
  'validade': validade,
  'quantidade': quantidade,
  'quantidadeReservada': reservada,
  'quantidadeDisponivel': quantidade - reservada,
};

DioException semRede(RequisicaoFalsa r) => DioException.connectionError(
  requestOptions: RequestOptions(path: r.caminho),
  reason: 'sem rede',
);
