import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/utils.dart';
import '../generated/l10n.dart';
import 'home_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../components/custom_snack_bar.dart';

class SmsOtpVerificationScreen extends StatefulWidget {
  final String phone;

  const SmsOtpVerificationScreen({Key? key, required this.phone}) : super(key: key);

  @override
  _SmsOtpVerificationScreenState createState() => _SmsOtpVerificationScreenState();
}

class _SmsOtpVerificationScreenState extends State<SmsOtpVerificationScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final otp = _otpController.text.trim();

    try {
      await supabase.auth.verifyOTP(
        phone: widget.phone,
        token: otp,
        type: OtpType.sms,
      );

      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).verificationSuccess,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on AuthException catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        e.message,
      );
    } catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).verificationFailed,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).verifyPhone),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                S.of(context).enterOtp,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                child: _isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(S.of(context).verify),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
