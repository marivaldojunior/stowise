// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funcionalidade_ia.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FuncionalidadeIa _$mapeamento = const FuncionalidadeIa._('mapeamento');
const FuncionalidadeIa _$casamentoItens = const FuncionalidadeIa._('casamentoItens');
const FuncionalidadeIa _$camera = const FuncionalidadeIa._('camera');
const FuncionalidadeIa _$cadastroPorFoto = const FuncionalidadeIa._('cadastroPorFoto');
const FuncionalidadeIa _$consulta = const FuncionalidadeIa._('consulta');
const FuncionalidadeIa _$embeddings = const FuncionalidadeIa._('embeddings');
const FuncionalidadeIa _$documentos = const FuncionalidadeIa._('documentos');
const FuncionalidadeIa _$leituraPlaqueta = const FuncionalidadeIa._('leituraPlaqueta');
const FuncionalidadeIa _$estadoConservacao = const FuncionalidadeIa._('estadoConservacao');
const FuncionalidadeIa _$casamentoBens = const FuncionalidadeIa._('casamentoBens');

FuncionalidadeIa _$valueOf(String name) {
  switch (name) {
    case 'mapeamento':
      return _$mapeamento;
    case 'casamentoItens':
      return _$casamentoItens;
    case 'camera':
      return _$camera;
    case 'cadastroPorFoto':
      return _$cadastroPorFoto;
    case 'consulta':
      return _$consulta;
    case 'embeddings':
      return _$embeddings;
    case 'documentos':
      return _$documentos;
    case 'leituraPlaqueta':
      return _$leituraPlaqueta;
    case 'estadoConservacao':
      return _$estadoConservacao;
    case 'casamentoBens':
      return _$casamentoBens;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FuncionalidadeIa> _$values = BuiltSet<FuncionalidadeIa>(const <FuncionalidadeIa>[
  _$mapeamento,
  _$casamentoItens,
  _$camera,
  _$cadastroPorFoto,
  _$consulta,
  _$embeddings,
  _$documentos,
  _$leituraPlaqueta,
  _$estadoConservacao,
  _$casamentoBens,
]);

class _$FuncionalidadeIaMeta {
  const _$FuncionalidadeIaMeta();
  FuncionalidadeIa get mapeamento => _$mapeamento;
  FuncionalidadeIa get casamentoItens => _$casamentoItens;
  FuncionalidadeIa get camera => _$camera;
  FuncionalidadeIa get cadastroPorFoto => _$cadastroPorFoto;
  FuncionalidadeIa get consulta => _$consulta;
  FuncionalidadeIa get embeddings => _$embeddings;
  FuncionalidadeIa get documentos => _$documentos;
  FuncionalidadeIa get leituraPlaqueta => _$leituraPlaqueta;
  FuncionalidadeIa get estadoConservacao => _$estadoConservacao;
  FuncionalidadeIa get casamentoBens => _$casamentoBens;
  FuncionalidadeIa valueOf(String name) => _$valueOf(name);
  BuiltSet<FuncionalidadeIa> get values => _$values;
}

abstract class _$FuncionalidadeIaMixin {
  // ignore: non_constant_identifier_names
  _$FuncionalidadeIaMeta get FuncionalidadeIa => const _$FuncionalidadeIaMeta();
}

Serializer<FuncionalidadeIa> _$funcionalidadeIaSerializer = _$FuncionalidadeIaSerializer();

class _$FuncionalidadeIaSerializer implements PrimitiveSerializer<FuncionalidadeIa> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'mapeamento': 'Mapeamento',
    'casamentoItens': 'CasamentoItens',
    'camera': 'Camera',
    'cadastroPorFoto': 'CadastroPorFoto',
    'consulta': 'Consulta',
    'embeddings': 'Embeddings',
    'documentos': 'Documentos',
    'leituraPlaqueta': 'LeituraPlaqueta',
    'estadoConservacao': 'EstadoConservacao',
    'casamentoBens': 'CasamentoBens',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Mapeamento': 'mapeamento',
    'CasamentoItens': 'casamentoItens',
    'Camera': 'camera',
    'CadastroPorFoto': 'cadastroPorFoto',
    'Consulta': 'consulta',
    'Embeddings': 'embeddings',
    'Documentos': 'documentos',
    'LeituraPlaqueta': 'leituraPlaqueta',
    'EstadoConservacao': 'estadoConservacao',
    'CasamentoBens': 'casamentoBens',
  };

  @override
  final Iterable<Type> types = const <Type>[FuncionalidadeIa];
  @override
  final String wireName = 'FuncionalidadeIa';

  @override
  Object serialize(Serializers serializers, FuncionalidadeIa object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FuncionalidadeIa deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FuncionalidadeIa.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
