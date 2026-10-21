//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'status_tarefa_armazenagem.g.dart';

class StatusTarefaArmazenagem extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Pendente')
  static const StatusTarefaArmazenagem pendente = _$pendente;
  @BuiltValueEnumConst(wireName: r'Concluida')
  static const StatusTarefaArmazenagem concluida = _$concluida;
  @BuiltValueEnumConst(wireName: r'Divergente')
  static const StatusTarefaArmazenagem divergente = _$divergente;

  static Serializer<StatusTarefaArmazenagem> get serializer => _$statusTarefaArmazenagemSerializer;

  const StatusTarefaArmazenagem._(String name) : super(name);

  static BuiltSet<StatusTarefaArmazenagem> get values => _$values;
  static StatusTarefaArmazenagem valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class StatusTarefaArmazenagemMixin = Object with _$StatusTarefaArmazenagemMixin;
