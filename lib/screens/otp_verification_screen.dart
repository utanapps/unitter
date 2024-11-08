// lib/screens/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpodのインポートを追加
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/custom_snack_bar.dart';
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart'; // プロバイダーのインポートを追加
import '../services/supabase_service.dart';
import 'dashboard_screen.dart';
import '../components/custom_text_field.dart';
import '../utils/utils.dart';
import '../utils/validators.dart'; // サービスをインポート

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  OtpVerificationScreen({required this.email});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  late SupabaseService supabaseService; // SupabaseServiceのインスタンスを定義
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
  }

  void _verifyOtp() async {
    if (!_formKey.currentState!.validate()) {
      return; // フォームが無効の場合は処理を中断
    }

    final otp = _otpController.text.trim();

    try {
      final res = await supabaseService.client.auth.verifyOTP(
        type: OtpType.signup, // 列挙型を使用
        email: widget.email,
        token: otp,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen()),
        (_) => false,
      );
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).verificationSuccess,
      );
    } on AuthException catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).verificationFailed,
      );
    } catch (e) {
      print(e);
      // その他のエラーハンドリング
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).verificationFailed,
      );
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
    });
    try {
      await supabaseService.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).sendVerificationCode,
      );
    } catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).error,
      );
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).verificationTitle),
        automaticallyImplyLeading: false, // 戻るボタンを非表示にする
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('${S.of(context).enterCodeMessage} ${widget.email}'),
              CustomTextField(
                controller: _otpController,
                label: S.of(context).otpLabel,
                keyboardType: TextInputType.number,
                validator: (value) {
                  return validateOtp(
                    value,
                    S.of(context).enterVerificationCode,
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: Text(S.of(context).verifyButton),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isResending ? null : _resendOtp,
                child: _isResending
                    ? CircularProgressIndicator()
                    : Text(S.of(context).resendOtpButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
