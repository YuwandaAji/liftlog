import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    await context.read<AuthProvider>().login(_email.text.trim(), _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Brand(),
                const SizedBox(height: 24),
                const _Hero(
                  asset: 'assets/images/auth_login.png',
                  eyebrow: 'DISIPLIN HARIAN',
                  title: 'CATAT. EVALUASI. LAMPAUI.',
                  height: 160,
                ),
                const SizedBox(height: 28),
                Text('MASUK', style: text.displayMedium),
                const SizedBox(height: 8),
                const Text(
                  'Lanjutkan progres latihan mandiri di rumah.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 28),
                AppTextField(
                  controller: _email,
                  label: 'Email',
                  hint: 'nama@email.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _password,
                  label: 'Kata sandi',
                  hint: 'Kata sandi Anda',
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  validator: (v) => Validators.required(v, 'Kata sandi'),
                ),
                if (auth.error != null) ...[
                  const SizedBox(height: 16),
                  Text(auth.error!, style: const TextStyle(color: AppColors.danger)),
                ],
                const SizedBox(height: 28),
                AppButton(label: 'MASUK', loading: auth.loading, onPressed: _submit),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthProvider>().clearError();
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Belum punya akun? ',
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                        children: const [
                          TextSpan(
                            text: 'Daftar',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'LiftLog bukan aplikasi medis dan tidak memberikan saran kesehatan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text('LIFTLOG', style: text.titleLarge?.copyWith(fontSize: 28)),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'HOME WORKOUT TRACKER',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  final String asset;
  final String eyebrow;
  final String title;
  final double height;

  const _Hero({
    required this.asset,
    required this.eyebrow,
    required this.title,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) =>
                  const ColoredBox(color: AppColors.surfaceHigh),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x33000000), Color(0xCC000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.lime,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(title, style: text.titleLarge?.copyWith(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}