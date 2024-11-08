import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../utils/utils.dart';
import '../generated/l10n.dart';
import 'sms_otp_verification_screen.dart';
import 'home_screen.dart'; // ホームスクリーンのインポート

import '../components/custom_snack_bar.dart'; // CustomSnackBarのインポート

class SmsSignupScreen extends StatefulWidget {
  const SmsSignupScreen({Key? key}) : super(key: key);

  @override
  _SmsSignupScreenState createState() => _SmsSignupScreenState();
}

class _SmsSignupScreenState extends State<SmsSignupScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PhoneNumber? _phoneNumber;
  bool _isLoading = false;
  bool _codeSent = false;

  Future<void> _signupWithPhone() async {
    if (!_formKey.currentState!.validate()) {
      return; // フォームが無効な場合は処理を中断
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String formattedPhone = _phoneNumber?.phoneNumber ?? '';
      if (formattedPhone.isEmpty) {
        throw Exception('有効な電話番号を入力してください。');
      }

      // OTPを送信
      await supabase.auth.signInWithOtp(
        phone: formattedPhone,
      );

      // OTPが正常に送信された場合に画面を遷移
      _navigateToSmsOtpVerification();

      // メッセージ表示
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).codeSentMessage,
      );
    } on AuthException catch (e) {
      // Supabaseの認証例外をキャッチ
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        e.message,
      );
    } catch (e) {
      // その他の例外をキャッチ
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).errorOccurred,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToSmsOtpVerification() {
    String formattedPhone = _phoneNumber?.phoneNumber ?? '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SmsOtpVerificationScreen(
          phone: formattedPhone,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).smsSignup, // タイトル
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 50),
        child: _codeSent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:16),
                  Text(
                    S.of(context).codeSentInfo,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: S.of(context).verifyCode,
                    onPressed: () => _navigateToSmsOtpVerification(),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        _phoneNumber = number;
                      },
                      onInputValidated: (bool value) {
                        // バリデーション結果に応じて処理を行う場合
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DROPDOWN,
                        useEmoji: true,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: PhoneNumber(isoCode: 'JP'),
                      textFieldController: _phoneController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        _phoneNumber = number;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).enterPhoneNumber;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: S.of(context).sendCode,
                      onPressed: () => _signupWithPhone(),
                    ),
                    // ElevatedButton(
                    //   onPressed: _isLoading ? null : _signupWithPhone,
                    //   child: _isLoading
                    //       ? const CircularProgressIndicator(
                    //           color: Colors.white,
                    //         )
                    //       : Text(S.of(context).sendCode),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}
