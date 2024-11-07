import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/custom_snack_bar.dart';
import '../components/custom_text_field.dart';
import '../generated/l10n.dart';
import '../services/supabase_service.dart';
import '../utils/utils.dart';
import '../utils/validators.dart';

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
      final currentUser = SupabaseService().getCurrentUser();
      if (currentUser != null) {
        _email = currentUser.email;
        _emailController.text = currentUser.email!;
      }
    }
  }

  void _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _email ?? _emailController.text.trim();

    try {
      await supabase.auth.resetPasswordForEmail(email);
      setState(() {
        _otpSent = true;
      });
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).otpSentMessage,
      );
    } on AuthException catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).errorLabel + e.message,
      );
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          ScaffoldMessenger.of(context),
          S.of(context).generalErrorMessage,
        );
      }
    }
  }

  void _verifyOtpAndUpdatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final otp = _otpController.text.trim();
    final newPassword = _newPasswordController.text;
    final email = _email ?? _emailController.text.trim();

    try {
      final res = await supabase.auth.verifyOTP(
        type: OtpType.recovery,
        email: email,
        token: otp,
      );

      if (res.session != null) {
        final updateRes = await supabase.auth.updateUser(
          UserAttributes(password: newPassword),
        );

        if (updateRes.user != null) {
          if (mounted) {
            CustomSnackBar.show(
              ScaffoldMessenger.of(context),
              S.of(context).successChangePassword,
            );
          }
          Navigator.pop(context);
        } else {
          if (mounted) {
            CustomSnackBar.show(
              ScaffoldMessenger.of(context),
              S.of(context).failedChangePassword,
            );
          }
        }
      }
    } on AuthException catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).otpVerificationFailedMessage,
      );
    } catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).generalErrorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).passwordResetTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: _otpSent
            ? Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                autoDismissKeyboard: true,
                autoFocus: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                ),
                onChanged: (value) {},
                validator: (value) {
                  return validateOtp(
                    value,
                    S.of(context).enterVerificationCode,
                  );
                },
              ),
              Text(S.of(context).enterOtpMessage),
              const SizedBox(height: 40),
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
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: _verifyOtpAndUpdatePassword,
                child: Text(S.of(context).updatePasswordButton),
              ),
            ],
          ),
        )
            : Form(
          key: _formKey,
          child: Column(
            children: [
              if (!widget.isFromSignin) ...[
                Text(S.of(context).sendOtpInstruction),
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
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: _sendOtp,
                child: Text(S.of(context).sendOtpButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
