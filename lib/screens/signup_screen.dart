import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/custom_snack_bar.dart';
import '../components/custom_text_field.dart';
import '../generated/l10n.dart';
import '../utils/utils.dart';
import '../utils/validators.dart';
import 'otp_verification_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  void _signup() async {
    if (!_formKey.currentState!.validate()) {
      return; // フォームが無効の場合は処理を中断
    }
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // バリデーションチェック
    if (!_validateEmail(email)) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).invalidEmailMessage,
      );
      return;
    }

    if (!_validatePassword(password)) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).invalidPasswordMessage,
      );
      return;
    }

    try {
      // ユーザーをサインアップ
       await supabase.auth.signUp(
        email: email,
        password: password,
      );

      // OTP認証画面へ遷移
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(email: email),
        ),
      );
    } on AuthException catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).error,
      );
    } catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).error,
      );
    }
  }

  bool _validateEmail(String email) {
    // 基本的なメール形式の正規表現
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegExp.hasMatch(email);
  }

  bool _validatePassword(String password) {
    // 8文字以上で、英字と数字の両方を含むかをチェック
    final lengthCheck = password.length >= 8;
    final letterCheck = RegExp(r'[A-Za-z]').hasMatch(password);
    final numberCheck = RegExp(r'[0-9]').hasMatch(password);
    return lengthCheck && letterCheck && numberCheck;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signUp),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller:  _emailController,
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
                  return validatePassword(
                    value,
                    S.of(context).enterPassword,
                    S.of(context).passwordTooShort,
                    S.of(context).passwordNeedsUppercase,
                    S.of(context).passwordNeedsLowercase,
                    S.of(context).passwordNeedsNumber,
                    S.of(context).passwordNeedsSpecialCharacter,
                  );
                },
              ),
              ElevatedButton(
                onPressed: _signup,
                child: Text(S.of(context).signUp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
