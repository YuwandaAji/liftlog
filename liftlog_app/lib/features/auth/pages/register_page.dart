import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _agreed = false;
  bool _agreeError = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _toggleAgree(bool value) => setState(() {
        _agreed = value;
        if (value) _agreeError = false;
      });

  Future<void> _submit() async {
    final formOk = _form.currentState!.validate();
    if (!_agreed) setState(() => _agreeError = true);
    if (!formOk || !_agreed) return;

    // Desain tidak punya kolom ulangi sandi; kirim sandi yang sama sebagai konfirmasi.
    final ok = await context.read<AuthProvider>().register(
          _name.text.trim(), _email.text.trim(), _password.text, _password.text);
    // AuthGate sudah berpindah ke Onboarding; tutup halaman Register di atasnya.
    if (ok && mounted) Navigator.of(context).popUntil((r) => r.isFirst);
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
                  asset: 'assets/images/auth_register.png',
                  eyebrow: 'MULAI PERJALANAN',
                  title: 'BANGUN KEKUATAN DARI RUMAH.',
                  height: 160,
                ),
                const SizedBox(height: 28),
                Text('DAFTAR', style: text.displayMedium),
                const SizedBox(height: 8),
                const Text(
                  'Mulai catat dan pantau progres latihan mandiri.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 28),
                AppTextField(
                  controller: _name,
                  label: 'Nama lengkap',
                  hint: 'Nama Anda',
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.required(v, 'Nama'),
                ),
                const SizedBox(height: 20),
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
                  hint: 'Minimal 8 karakter',
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  validator: Validators.password,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreed,
                        onChanged: (v) => _toggleAgree(v ?? false),
                        activeColor: AppColors.lime,
                        checkColor: Colors.black,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: WidgetStateBorderSide.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return const BorderSide(color: AppColors.lime, width: 1.5);
                          }
                          return BorderSide(
                            color: _agreeError ? AppColors.danger : AppColors.textSecondary,
                            width: 1.5,
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _toggleAgree(!_agreed),
                        child: const Text(
                          'Dengan mendaftar, Anda menyetujui Ketentuan & Privasi LiftLog.',
                          style: TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_agreeError)
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 36),
                    child: Text(
                      'Anda harus menyetujui Ketentuan & Privasi untuk mendaftar.',
                      style: TextStyle(fontSize: 12, color: AppColors.danger),
                    ),
                  ),
                if (auth.error != null) ...[
                  const SizedBox(height: 16),
                  Text(auth.error!, style: const TextStyle(color: AppColors.danger)),
                ],
                const SizedBox(height: 24),
                AppButton(label: 'DAFTAR', loading: auth.loading, onPressed: _submit),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthProvider>().clearError();
                      Navigator.pop(context);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                        children: const [
                          TextSpan(
                            text: 'Masuk',
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