import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/failures.dart';
import 'auth_viewmodel.dart';
import 'login_credentials.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaVisivel = false;

  // Raio único usado em campos, banner de erro — mantém consistência visual.
  static const _radius = BorderRadius.all(Radius.circular(12));

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _showComingSoon(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authViewModelProvider.notifier).login(
      LoginCredentials(
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      ),
    );
  }

  /// Decoração unificada para os campos — filled com borda de contraste adequado.
  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String label,
    required IconData prefixIcon,
    String? hintText,
    Widget? suffixIcon,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: cs.surfaceContainerHighest.withAlpha(80),
      border: OutlineInputBorder(
        borderRadius: _radius,
        borderSide: BorderSide(color: cs.outline.withAlpha(120)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: _radius,
        borderSide: BorderSide(color: cs.outline.withAlpha(120)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _radius,
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: _radius,
        borderSide: BorderSide(color: cs.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: _radius,
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    final errorMessage =
        authState.hasError && authState.error is Failure
            ? (authState.error as Failure).message
            : null;

    return Scaffold(
      // Teclado sobrepõe o layout — footer não sobe junto com o teclado.
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        // Tap fora dos campos remove o foco e oculta o teclado.
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
        child: Column(
          children: [
            // ── Conteúdo principal (scrollável) ──────────────────────────
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Logo ────────────────────────────────────────
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(100),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.asset(
                                'assets/splash/logo.png',
                                width: 160,
                                height: 160,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Hierarquia tipográfica ───────────────────────
                        // Item 4: âncora visual acima do subtítulo.
                        Text(
                          'Bem-vindo de volta',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Faça login para continuar',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(140),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // ── Campo e-mail ─────────────────────────────────
                        TextFormField(
                          controller: _emailController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          decoration: _fieldDecoration(
                            context,
                            label: 'E-mail',
                            prefixIcon: Icons.email_outlined,
                            hintText: 'professor@escola.com',
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Informe o e-mail.';
                            }
                            if (!v.contains('@') || !v.contains('.')) {
                              return 'E-mail inválido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // ── Campo senha ──────────────────────────────────
                        TextFormField(
                          controller: _senhaController,
                          enabled: !isLoading,
                          obscureText: !_senhaVisivel,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: _fieldDecoration(
                            context,
                            label: 'Senha',
                            prefixIcon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _senhaVisivel
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              tooltip:
                                  _senhaVisivel
                                      ? 'Ocultar senha'
                                      : 'Mostrar senha',
                              onPressed:
                                  () => setState(
                                    () => _senhaVisivel = !_senhaVisivel,
                                  ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Informe a senha.';
                            }
                            if (v.length < 4) return 'Senha muito curta.';
                            return null;
                          },
                        ),

                        // ── Banner de erro ───────────────────────────────
                        if (errorMessage != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  color: theme.colorScheme.onErrorContainer,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color:
                                          theme.colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 28),

                        // ── Botão pill (item 7) ──────────────────────────
                        FilledButton(
                          onPressed: isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: const StadiumBorder(),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    'Entrar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                        const SizedBox(height: 16),

                        // ── Links rápidos — só texto, peso uniforme (item 8)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed:
                                  () => _showComingSoon(
                                    context,
                                    'Recuperação de senha em breve.',
                                  ),
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                              ),
                              child: const Text('Esqueceu a senha?'),
                            ),
                            TextButton(
                              onPressed:
                                  () => _showComingSoon(
                                    context,
                                    'Suporte: suporte@professoravalia.com.br',
                                  ),
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                              ),
                              child: const Text('Suporte'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Footer ancorado na base (item 1 & 6) ─────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1, thickness: 0.5),
                  const SizedBox(height: 12),
                  Text(
                    '© 2026 • Powered by André G. S. Paschoa',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(100),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  // Item 5: separador • no lugar do pipe |
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed:
                            () => _showComingSoon(
                              context,
                              'Termos de Uso em breve.',
                            ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: theme.textTheme.labelSmall,
                        ),
                        child: const Text('Termos de Uso'),
                      ),
                      Text(
                        '•',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(100),
                        ),
                      ),
                      TextButton(
                        onPressed:
                            () => _showComingSoon(
                              context,
                              'Política de Privacidade em breve.',
                            ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: theme.textTheme.labelSmall,
                        ),
                        child: const Text('Política de Privacidade'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}

