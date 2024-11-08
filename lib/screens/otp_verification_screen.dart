// lib/screens/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpodのインポートを追加
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_snack_bar.dart';
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart'; // プロバイダーのインポートを追加
import '../services/supabase_service.dart';
import 'dashboard_screen.dart';
import '../components/custom_text_field.dart';
import '../utils/utils.dart';
import '../utils/validators.dart';
import 'home_screen.dart'; // サービスをインポート

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
        MaterialPageRoute(builder: (context) => HomeScreen()),
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
      appBar: CustomAppBar(
        title: S.of(context).verificationTitle, // タイトル
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Text('${S.of(context).enterCodeMessage}'),
                  SizedBox(height: 20,),
        
                  Text('${widget.email}'),
        
                  SizedBox(height: 20,),
        
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    autoDismissKeyboard: true,
                    autoFocus: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      fieldOuterPadding: EdgeInsets.all(0),
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).enterOtp;
                      }
                      if (value.length != 6) {
                        return S.of(context).invalidOtp;
                      }
                      if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                        return S.of(context).invalidOtp;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 6),
                  CustomButton(
                    text: S.of(context).verifyButton,
                    onPressed: () => _verifyOtp(),
                  ),
                  const SizedBox(height: 6),
                  CustomButton(
                    text: S.of(context).resendOtpButton,
                    onPressed: () =>  _resendOtp(),
                  ),
                  // ElevatedButton(
                  //   onPressed: _isResending ? null : _resendOtp,
                  //   child: _isResending
                  //       ? CircularProgressIndicator()
                  //       : Text(S.of(context).resendOtpButton),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
