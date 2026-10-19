import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../app/tema.dart';
import '../../../app/widgets/identidade.dart';

/// Formatos lidos no armazém: códigos de produto (EAN/GTIN, UPC), etiquetas de endereço e de lote (Code 128, Code 39)
/// e QR/DataMatrix. Limitar os formatos deixa a leitura mais rápida e evita leituras falsas.
const formatosLidos = [
  BarcodeFormat.ean13,
  BarcodeFormat.ean8,
  BarcodeFormat.upcA,
  BarcodeFormat.upcE,
  BarcodeFormat.code128,
  BarcodeFormat.code39,
  BarcodeFormat.itf2of5,
  BarcodeFormat.qrCode,
  BarcodeFormat.dataMatrix,
];

/// Leitura pela câmera (ML Kit no próprio aparelho; a imagem não sai dele). Devolve o código lido ou digitado, ou
/// null se o usuário voltar.
class LeituraPage extends StatefulWidget {
  const LeituraPage({required this.titulo, super.key});

  final String titulo;

  @override
  State<LeituraPage> createState() => _LeituraPageState();
}

class _LeituraPageState extends State<LeituraPage> {
  final _camera = MobileScannerController(formats: formatosLidos, detectionSpeed: DetectionSpeed.noDuplicates);
  bool _concluida = false;

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  void _concluir(String? codigo) {
    final limpo = codigo?.trim();
    if (_concluida || limpo == null || limpo.isEmpty) {
      return;
    }

    _concluida = true;
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(limpo);
  }

  Future<void> _digitar() async {
    final codigo = await showDialog<String>(context: context, builder: (context) => const _DigitarCodigo());
    _concluir(codigo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraStowise(
        titulo: widget.titulo,
        acoes: [
          ValueListenableBuilder(
            valueListenable: _camera,
            builder: (context, estado, _) => IconButton(
              tooltip: estado.torchState == TorchState.on ? 'Desligar a lanterna' : 'Ligar a lanterna',
              icon: Icon(estado.torchState == TorchState.on ? Icons.flash_on : Icons.flash_off),
              onPressed: estado.torchState == TorchState.unavailable ? null : _camera.toggleTorch,
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _camera,
            onDetect: (captura) => _concluir(captura.barcodes.firstOrNull?.rawValue),
            errorBuilder: (context, erro) => _ErroCamera(erro: erro, onDigitar: _digitar),
          ),
          // Moldura: mostra onde apontar.
          IgnorePointer(
            child: Center(
              child: Container(
                width: 280,
                height: 180,
                // Âmbar da fita de segurança, com brilho, para ver bem sobre qualquer imagem.
                decoration: BoxDecoration(
                  border: Border.all(color: context.cores.sinal, width: 3),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: context.cores.sinal.withValues(alpha: 0.45), blurRadius: 24)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SafeArea(
              child: FilledButton.tonalIcon(
                onPressed: _digitar,
                icon: const Icon(Icons.keyboard),
                label: const Text('Digitar o código'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErroCamera extends StatelessWidget {
  const _ErroCamera({required this.erro, required this.onDigitar});

  final MobileScannerException erro;
  final VoidCallback onDigitar;

  @override
  Widget build(BuildContext context) {
    final semPermissao = erro.errorCode == MobileScannerErrorCode.permissionDenied;
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography_outlined, size: 48),
            const SizedBox(height: 16),
            Text(
              semPermissao
                  ? 'O Stowise não tem permissão para usar a câmera. Libere nas configurações do aparelho ou digite o código.'
                  : 'A câmera não abriu. Digite o código.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onDigitar, child: const Text('Digitar o código')),
          ],
        ),
      ),
    );
  }
}

class _DigitarCodigo extends StatefulWidget {
  const _DigitarCodigo();

  @override
  State<_DigitarCodigo> createState() => _DigitarCodigoState();
}

class _DigitarCodigoState extends State<_DigitarCodigo> {
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Digitar o código'),
      content: TextField(
        controller: _texto,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Código'),
        textInputAction: TextInputAction.done,
        onSubmitted: (valor) => Navigator.of(context).pop(valor),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.of(context).pop(_texto.text), child: const Text('Usar')),
      ],
    );
  }
}
