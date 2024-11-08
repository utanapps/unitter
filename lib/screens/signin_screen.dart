import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unitter/screens/sms_signup_screen.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_snack_bar.dart';
import '../components/custom_text_field.dart';
import '../components/language_dropdown.dart';
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart';
import '../utils/validators.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'otp_verification_screen.dart';
import 'password_reset_screen.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  // final supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signin() async {
    if (!_formKey.currentState!.validate()) {
      return; // フォームが無効の場合は処理を中断
    }
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final supabaseService = ref.read(supabaseServiceProvider);

      final res = await supabaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (res.session != null) {
        final user = supabaseService.getCurrentUser();
        if (user != null && user.emailConfirmedAt != null) {
          // ホーム画面へ遷移
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (_) => false,
            );
          }
        } else {
          // OTP認証画面へ遷移
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(email: email),
              ),
            );
          }
        }
      }
    } on AuthException catch (e) {
      if (e.message == 'Email not confirmed') {
        // OTP認証画面へ遷移
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(email: email),
            ),
          );
        }
      } else if (e.message == 'Invalid login credentials') {
        CustomSnackBar.show(
          ScaffoldMessenger.of(context),
          S.of(context).loginErrorMessage,
        );
      } else {
        CustomSnackBar.show(
          ScaffoldMessenger.of(context),
          S.of(context).error,
        ); // その他のエラーハンドリング
      }
    } catch (e) {
      // その他のエラーハンドリング
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).error,
      );
    }
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  void _navigateToSmaSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SmsSignupScreen()),
    );
  }

  void _navigateToPasswordReset() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordResetScreen(isFromSignin: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: CustomAppBar(
        //   title: S.of(context).signIn, // タイトル
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Image.asset('assets/images/animals.webp',width: 350,),
                CustomTextField(
                  controller: _emailController,
                  label: S.of(context).email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return validateEmail(
                      value,
                      S.of(context).invalidEmailFormat,
                      S.of(context).enterEmail,
                    );
                  },
                ),
                CustomTextField(
                  controller: _passwordController,
                  label: S.of(context).password,
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                  validator: (value) {
                    return validateSimplePassword(
                      value,
                      S.of(context).enterPassword,
                    );
                  },
                ),
                CustomButton(
                  text: S.of(context).signIn,
                  onPressed: () => _signin(),
                ),
                TextButton(
                    onPressed: _navigateToSignup,
                    child: Text(S.of(context).signUp)),
                TextButton(
                    onPressed: _navigateToSmaSignup,
                    child: Text(S.of(context).smsSignup)),
                TextButton(
                    onPressed: _navigateToPasswordReset,
                    child: Text(S.of(context).forgotPassword)),
              ]),
            ),
          ),
        ));
  }
}
