import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/tema.dart';
import '../../../app/widgets/aviso.dart';
import '../../../app/widgets/identidade.dart';
import '../domain/sessao.dart';
import 'sessao_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formulario = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _enviando = false;
  bool _senhaVisivel = false;
  String? _erro;

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formulario.currentState!.validate()) {
      return;
    }

    setState(() {
      _enviando = true;
      _erro = null;
    });
    try {
      await ref.read(sessaoProvider.notifier).entrar(_email.text, _senha.text);
    } on FalhaAuth catch (falha) {
      if (mounted) {
        setState(() => _erro = falha.mensagem);
      }
    } finally {
      if (mounted) {
        setState(() => _enviando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final estado = ref.watch(sessaoProvider);
    final aviso = estado is Anonimo ? estado.aviso : null;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _Cabecalho(),
            Transform.translate(
              offset: const Offset(0, -36),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: tema.cardTheme.color,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: context.cores.sombraCartao,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                      child: Form(
                        key: _formulario,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Entrar no Stowise',
                              style: tema.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Use o e-mail e a senha da sua conta.',
                              style: tema.textTheme.bodyMedium?.copyWith(color: tema.colorScheme.onSurfaceVariant),
                            ),
                            if (aviso != null) ...[
                              const SizedBox(height: 16),
                              Aviso(texto: aviso, tom: TomAviso.aviso),
                            ],
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _email,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.username],
                              textInputAction: TextInputAction.next,
                              validator: (valor) => (valor ?? '').trim().isEmpty ? 'Informe o e-mail.' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _senha,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _senhaVisivel ? 'Esconder a senha' : 'Mostrar a senha',
                                  icon: Icon(_senhaVisivel ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                                  onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                                ),
                              ),
                              obscureText: !_senhaVisivel,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _entrar(),
                              validator: (valor) => (valor ?? '').isEmpty ? 'Informe a senha.' : null,
                            ),
                            if (_erro != null) ...[
                              const SizedBox(height: 16),
                              Aviso(texto: _erro!, tom: TomAviso.erro),
                            ],
                            const SizedBox(height: 24),
                            BotaoGradiente(
                              onPressed: _enviando ? null : _entrar,
                              child: _enviando
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Entrar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Topo do login: a marca, o lema e uma etiqueta de prateleira sobre a tinta.
class _Cabecalho extends StatelessWidget {
  const _Cabecalho();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = context.cores;
    return CabecalhoTinta(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 64),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MarcaStowise(clara: true),
            const SizedBox(height: 28),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Inventário e armazenagem '),
                  TextSpan(
                    text: 'com IA',
                    style: TextStyle(color: cores.ia2),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
              style: tema.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Leia o código, confira e registre. A IA só sugere.',
              style: tema.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.72)),
            ),
            const SizedBox(height: 20),
            ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 4, height: 18, color: cores.sinal),
                    const SizedBox(width: 8),
                    Text(
                      'A-01-1-1',
                      style: tema.textTheme.titleSmall?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: cores.tinta,
                      ),
                    ),
                    const SizedBox(width: 10),
                    CodigoDeBarras(cor: cores.tinta),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
