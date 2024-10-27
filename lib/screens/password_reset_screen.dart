import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/custom_text_field.dart';
import '../generated/l10n.dart';
import '../services/supabase_service.dart';
import '../utils/utils.dart';
import '../utils/validators.dart'; // サービスをインポート

class PasswordResetScreen extends ConsumerStatefulWidget {
  final bool isFromSignin;

  const PasswordResetScreen({super.key, this.isFromSignin = false});

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final supabase = SupabaseService().client;

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _otpSent = false;
  String? _email;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (!widget.isFromSignin) {
      // サインイン画面からではない場合、現在のユーザーのメールを設定
      final currentUser = SupabaseService().getCurrentUser();
      if (currentUser != null) {
        _email = currentUser.email;
        _emailController.text = currentUser.email!;
      }
    }
  }

  void _sendOtp() async {

    if (!_formKey.currentState!.validate()) {
      return; // フォームが無効の場合は処理を中断
    }

    final email = _email ?? _emailController.text.trim();

    try {
      // パスワードリセット用のOTPを送信
      await supabase.auth.resetPasswordForEmail(email);
      setState(() {
        _otpSent = true;
      });
    } on AuthException catch (e) {
      Utils.showMessageBottomSheet(context, S.of(context).errorLabel, e.message);
    } catch (e) {
      // その他のエラー
      if (mounted) {
        Utils.showMessageBottomSheet(context, S.of(context).errorLabel, S.of(context).error);
      }
    }
  }

  void _verifyOtpAndUpdatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return; // フォームが無効の場合は処理を中断
    }

    final otp = _otpController.text.trim();
    final newPassword = _newPasswordController.text;
    final email = _email ?? _emailController.text.trim();

    try {
      // OTPを検証してセッションを取得
      final res = await supabase.auth.verifyOTP(
        type: OtpType.recovery,
        email: email,
        token: otp,
      );

      if (res.session != null) {
        // パスワードを更新
        final updateRes = await supabase.auth.updateUser(
          UserAttributes(password: newPassword),
        );

        if (updateRes.user != null) {
          if (mounted) {
            Utils.showMessageBottomSheet(
                context, 'Error', S.of(context).successChangePassword);
          }
          Navigator.pop(context); // 前の画面に戻る
        } else {
          if (mounted) {
            Utils.showMessageBottomSheet(
                context, 'Error', S.of(context).failedChangePassword);
          }
        }
      }
    } on AuthException catch (e) {
      // エラーハンドリング
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTPコードの検証に失敗しました。もう一度お試しください。')));
    } catch (e) {
      print(e);
      // その他のエラー
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('エラーが発生しました')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('パスワードリセット'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _otpSent
            ? Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('メールに送信された認証コードを入力してください'),
                    CustomTextField(
                      controller: _otpController,
                      label: S.of(context).otpLabel,
                      validator: (value) {
                        return validateOtp(
                          value,
                          S.of(context).enterVerificationCode,
                        );
                      },
                    ),
                    CustomTextField(
                      controller: _newPasswordController,
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
                      onPressed: _verifyOtpAndUpdatePassword,
                      child: Text('パスワードを更新'),
                    ),
                  ],
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!widget.isFromSignin) ...[
                      Text('パスワード変更のための認証コードを送信します'),
                    ],
                    if (widget.isFromSignin || _email == null) ...[
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
                    ],
                    ElevatedButton(
                      onPressed: _sendOtp,
                      child: Text('認証コードを送信'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
