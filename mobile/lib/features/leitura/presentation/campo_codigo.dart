import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'leitura_page.dart';

/// Abre a leitura e devolve o código, ou null. Os testes trocam por um leitor falso (a câmera não existe no teste).
typedef Leitor = Future<String?> Function(BuildContext context, String titulo);

final leitorProvider = Provider<Leitor>(
  (ref) =>
      (context, titulo) => Navigator.of(
        context,
      ).push<String>(MaterialPageRoute(fullscreenDialog: true, builder: (context) => LeituraPage(titulo: titulo))),
);

/// Campo de código com três entradas: a câmera (botão), a digitação e o leitor físico do coletor em modo teclado
/// (Zebra DataWedge, Honeywell), que digita o código e envia Enter.
class CampoCodigo extends ConsumerStatefulWidget {
  const CampoCodigo({
    required this.rotulo,
    required this.onCodigo,
    this.tituloLeitura,
    this.erro,
    this.carregando = false,
    this.focoInicial = false,
    super.key,
  });

  final String rotulo;
  final String? tituloLeitura;
  final ValueChanged<String> onCodigo;
  final String? erro;
  final bool carregando;
  final bool focoInicial;

  @override
  ConsumerState<CampoCodigo> createState() => _CampoCodigoState();
}

class _CampoCodigoState extends ConsumerState<CampoCodigo> {
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  void _usar(String? codigo) {
    final limpo = codigo?.trim() ?? '';
    if (limpo.isEmpty) {
      return;
    }

    _texto.text = limpo;
    widget.onCodigo(limpo);
  }

  Future<void> _ler() async {
    final codigo = await ref.read(leitorProvider)(context, widget.tituloLeitura ?? widget.rotulo);
    if (mounted) {
      _usar(codigo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _texto,
      autofocus: widget.focoInicial,
      textInputAction: TextInputAction.search,
      onSubmitted: _usar,
      decoration: InputDecoration(
        labelText: widget.rotulo,
        errorText: widget.erro,
        suffixIcon: widget.carregando
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : IconButton(
                tooltip: 'Ler com a câmera: ${widget.rotulo}',
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: _ler,
              ),
      ),
    );
  }
}
