import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/generated/l10n.dart';
import 'package:unitter/components/language_dropdown.dart';
import 'package:unitter/services/supabase_service.dart';
import 'package:unitter/components/custom_text_field.dart';
import 'package:unitter/components/custom_snack_bar.dart';
import 'package:unitter/components/rounded_close_button.dart';
import 'package:unitter/components/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../providers/supabase_provider.dart';
import '../utils/validators.dart';

class EditEmailScreen extends ConsumerStatefulWidget {
  const EditEmailScreen({Key? key}) : super(key: key);

  @override
  EditEmailScreenState createState() => EditEmailScreenState();
}

class EditEmailScreenState extends ConsumerState<EditEmailScreen> {
  final _newEmailController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _otpSent = false;
  late final SupabaseService supabaseService;

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await supabaseService.updateUserEmail(
        newEmail: _newEmailController.text,
      );
      setState(() {
        _otpSent = true;
      });
      if (mounted) {
        CustomSnackBar.show(
          ScaffoldMessenger.of(context),
          S.of(context).emailChangeVerificationMessage,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          ScaffoldMessenger.of(context),
          S.of(context).error,
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(
            () => _isLoading = true
    );

    try {
      await supabaseService.verifyOtpAndChangeEmail(
        email: _newEmailController.text,
        token: _otpController.text,
      );
      if (mounted) {
        CustomSnackBar.show(
          ScaffoldMessenger.of(context),
          S.of(context).success,
        );
      }
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          ScaffoldMessenger.of(context),
          S.of(context).otpVerificationFailedMessage,
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedCloseButton(),
        actions: const [
          LanguageDropdown(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  PhosphorIcons.envelopeSimpleOpen(),
                  size: 70.0,
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (!_otpSent) ...[
                        CustomTextField(
                          controller: _newEmailController,
                          label: S.of(context).newEmail,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).enterEmail;
                            }
                            final emailRegex =
                                RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b');
                            if (!emailRegex.hasMatch(value)) {
                              return S.of(context).invalidEmailFormat;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                          text: S.of(context).sendOtpButton,
                          onPressed: _sendOtp,
                        ),
                      ] else ...[
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
                                value, S.of(context).enterVerificationCode);
                          },
                        ),
                        Text(S.of(context).enterOtpMessage),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _verifyOtp,
                          child: Text(S.of(context).verifyCode),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
