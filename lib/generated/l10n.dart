// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `🇬🇧`
  String get language {
    return Intl.message(
      '🇬🇧',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Password Recovery`
  String get passwordRecoveryPageTitle {
    return Intl.message(
      'Password Recovery',
      name: 'passwordRecoveryPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `You will receive an email with a link to reset your password. `
  String get passwordRecoveryPageDescription {
    return Intl.message(
      'You will receive an email with a link to reset your password. ',
      name: 'passwordRecoveryPageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Password recovery instructions have been sent to your email address. Please check your inbox and follow the link to reset your password.`
  String get passwordRecoveryMessage {
    return Intl.message(
      'Password recovery instructions have been sent to your email address. Please check your inbox and follow the link to reset your password.',
      name: 'passwordRecoveryMessage',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get PasswordResetPageTitle {
    return Intl.message(
      'Reset Password',
      name: 'PasswordResetPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Change your email address`
  String get changeEmailPageTitle {
    return Intl.message(
      'Change your email address',
      name: 'changeEmailPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmailFormat {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmailFormat',
      desc: '',
      args: [],
    );
  }

  /// `new email`
  String get newEmail {
    return Intl.message(
      'new email',
      name: 'newEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get newPassword {
    return Intl.message(
      'Enter new password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Min 8 characters.`
  String get passwordTooShort {
    return Intl.message(
      'Min 8 characters.',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `One uppercase letter (A-Z).`
  String get passwordNeedsUppercase {
    return Intl.message(
      'One uppercase letter (A-Z).',
      name: 'passwordNeedsUppercase',
      desc: '',
      args: [],
    );
  }

  /// `One lowercase letter (a-z).`
  String get passwordNeedsLowercase {
    return Intl.message(
      'One lowercase letter (a-z).',
      name: 'passwordNeedsLowercase',
      desc: '',
      args: [],
    );
  }

  /// `One number (0-9).`
  String get passwordNeedsNumber {
    return Intl.message(
      'One number (0-9).',
      name: 'passwordNeedsNumber',
      desc: '',
      args: [],
    );
  }

  /// `One special character (!@#$%^&*(),.?":{}|<>).`
  String get passwordNeedsSpecialCharacter {
    return Intl.message(
      'One special character (!@#\$%^&*(),.?":{}|<>).',
      name: 'passwordNeedsSpecialCharacter',
      desc: '',
      args: [],
    );
  }

  /// `Change Email`
  String get changeEmail {
    return Intl.message(
      'Change Email',
      name: 'changeEmail',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been successfully updated.`
  String get successChangePassword {
    return Intl.message(
      'Your password has been successfully updated.',
      name: 'successChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update your password. Please try again or contact support.`
  String get failedChangePassword {
    return Intl.message(
      'Failed to update your password. Please try again or contact support.',
      name: 'failedChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Your email address has been successfully updated.`
  String get successChangeEmail {
    return Intl.message(
      'Your email address has been successfully updated.',
      name: 'successChangeEmail',
      desc: '',
      args: [],
    );
  }

  /// `username`
  String get username {
    return Intl.message(
      'username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get enterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a username`
  String get enterUsername {
    return Intl.message(
      'Please enter a username',
      name: 'enterUsername',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your email address. A confirmation link has been sent to the email provided.`
  String get verifyEmail {
    return Intl.message(
      'Please verify your email address. A confirmation link has been sent to the email provided.',
      name: 'verifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred. Please try again.`
  String get unknownError {
    return Intl.message(
      'An unknown error occurred. Please try again.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get btnResetPassword {
    return Intl.message(
      'Reset password',
      name: 'btnResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `editTradingAccount`
  String get editTradingAccount {
    return Intl.message(
      'editTradingAccount',
      name: 'editTradingAccount',
      desc: '',
      args: [],
    );
  }

  /// `accountNumber`
  String get accountNumber {
    return Intl.message(
      'accountNumber',
      name: 'accountNumber',
      desc: '',
      args: [],
    );
  }

  /// `savingData`
  String get fieldCannotBeEmpty {
    return Intl.message(
      'savingData',
      name: 'fieldCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Type a message`
  String get typeAMessage {
    return Intl.message(
      'Type a message',
      name: 'typeAMessage',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Bank Name`
  String get bankName {
    return Intl.message(
      'Bank Name',
      name: 'bankName',
      desc: '',
      args: [],
    );
  }

  /// `Bank Code`
  String get bankCode {
    return Intl.message(
      'Bank Code',
      name: 'bankCode',
      desc: '',
      args: [],
    );
  }

  /// `Branch Name`
  String get branchName {
    return Intl.message(
      'Branch Name',
      name: 'branchName',
      desc: '',
      args: [],
    );
  }

  /// `Branch Code`
  String get branchCode {
    return Intl.message(
      'Branch Code',
      name: 'branchCode',
      desc: '',
      args: [],
    );
  }

  /// `Account Number`
  String get bankAccountNumber {
    return Intl.message(
      'Account Number',
      name: 'bankAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Account Holder Name`
  String get accountHolderName {
    return Intl.message(
      'Account Holder Name',
      name: 'accountHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully.`
  String get successChangeProfile {
    return Intl.message(
      'Profile updated successfully.',
      name: 'successChangeProfile',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Support chat`
  String get supportPageName {
    return Intl.message(
      'Support chat',
      name: 'supportPageName',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Payment setting`
  String get bankDetail {
    return Intl.message(
      'Payment setting',
      name: 'bankDetail',
      desc: '',
      args: [],
    );
  }

  /// `Account Email Address`
  String get tradingAccountEmail {
    return Intl.message(
      'Account Email Address',
      name: 'tradingAccountEmail',
      desc: '',
      args: [],
    );
  }

  /// `Account Holder Name`
  String get tradingAccountHolderName {
    return Intl.message(
      'Account Holder Name',
      name: 'tradingAccountHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Trading Account NUmber`
  String get tradingAccountNumber {
    return Intl.message(
      'Trading Account NUmber',
      name: 'tradingAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Additional info`
  String get additionalInfo {
    return Intl.message(
      'Additional info',
      name: 'additionalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Enter a Account Holder Name`
  String get enterTradingAccountHolderName {
    return Intl.message(
      'Enter a Account Holder Name',
      name: 'enterTradingAccountHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Enter a Trading Account Number`
  String get enterTradingAccountNumber {
    return Intl.message(
      'Enter a Trading Account Number',
      name: 'enterTradingAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Trading account successfully added`
  String get successInsertTradingAccount {
    return Intl.message(
      'Trading account successfully added',
      name: 'successInsertTradingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Add Trading Account`
  String get TradingAccountRegistrationTitle {
    return Intl.message(
      'Add Trading Account',
      name: 'TradingAccountRegistrationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get btnTitleTradingAccountRegistration {
    return Intl.message(
      'Submit',
      name: 'btnTitleTradingAccountRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Changes have been successfully completed.`
  String get successfullyCompleted {
    return Intl.message(
      'Changes have been successfully completed.',
      name: 'successfullyCompleted',
      desc: '',
      args: [],
    );
  }

  /// `This Week`
  String get thisWeek {
    return Intl.message(
      'This Week',
      name: 'thisWeek',
      desc: '',
      args: [],
    );
  }

  /// `Last Week`
  String get lastWeek {
    return Intl.message(
      'Last Week',
      name: 'lastWeek',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get noDataFound {
    return Intl.message(
      'No data found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Clear the Quest and get the Treasure!`
  String get loginPageTitle {
    return Intl.message(
      'Clear the Quest and get the Treasure!',
      name: 'loginPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email {
    return Intl.message(
      'email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password {
    return Intl.message(
      'password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get signUp {
    return Intl.message(
      'Create New Account',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Do you forget your password?`
  String get forgotPassword {
    return Intl.message(
      'Do you forget your password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed. Please check your email and password.`
  String get loginErrorMessage {
    return Intl.message(
      'Authentication failed. Please check your email and password.',
      name: 'loginErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Resend Verification Email`
  String get resendVerificationEmail {
    return Intl.message(
      'Resend Verification Email',
      name: 'resendVerificationEmail',
      desc: '',
      args: [],
    );
  }

  /// `Verification Email Resent`
  String get verificationEmailResent {
    return Intl.message(
      'Verification Email Resent',
      name: 'verificationEmailResent',
      desc: '',
      args: [],
    );
  }

  /// `Error Resending Email`
  String get resendEmailError {
    return Intl.message(
      'Error Resending Email',
      name: 'resendEmailError',
      desc: '',
      args: [],
    );
  }

  /// `Haven't received the verification email?`
  String get verificationEmailNotReceived {
    return Intl.message(
      'Haven\'t received the verification email?',
      name: 'verificationEmailNotReceived',
      desc: '',
      args: [],
    );
  }

  /// `Would you like us to resend it?`
  String get wouldYouLikeToResendEmail {
    return Intl.message(
      'Would you like us to resend it?',
      name: 'wouldYouLikeToResendEmail',
      desc: '',
      args: [],
    );
  }

  /// `No worries, just try one more time, yeah?`
  String get error {
    return Intl.message(
      'No worries, just try one more time, yeah?',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a email`
  String get enterEmail {
    return Intl.message(
      'Please enter a email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password.`
  String get enterPassword {
    return Intl.message(
      'Please enter a password.',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message(
      'Weekly',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message(
      'Monthly',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `Register Trading Account`
  String get registerTradingAccount {
    return Intl.message(
      'Register Trading Account',
      name: 'registerTradingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Verify Account`
  String get verifyAccount {
    return Intl.message(
      'Verify Account',
      name: 'verifyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create an account via the cashback site.`
  String get registerTradingAccountSub {
    return Intl.message(
      'Create an account via the cashback site.',
      name: 'registerTradingAccountSub',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Open support chat`
  String get openSupportChat {
    return Intl.message(
      'Open support chat',
      name: 'openSupportChat',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get darkMode {
    return Intl.message(
      'Dark mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Language Settings`
  String get languageMode {
    return Intl.message(
      'Language Settings',
      name: 'languageMode',
      desc: '',
      args: [],
    );
  }

  /// `Switch between dark and light mode.`
  String get darkModeDescription {
    return Intl.message(
      'Switch between dark and light mode.',
      name: 'darkModeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Change the app's language.`
  String get languageDescription {
    return Intl.message(
      'Change the app\'s language.',
      name: 'languageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Change profile.`
  String get profileDescription {
    return Intl.message(
      'Change profile.',
      name: 'profileDescription',
      desc: '',
      args: [],
    );
  }

  /// `Change payment detail.`
  String get paymentDescription {
    return Intl.message(
      'Change payment detail.',
      name: 'paymentDescription',
      desc: '',
      args: [],
    );
  }

  /// `End current session`
  String get logoutDescription {
    return Intl.message(
      'End current session',
      name: 'logoutDescription',
      desc: '',
      args: [],
    );
  }

  /// `Change email`
  String get emailChange {
    return Intl.message(
      'Change email',
      name: 'emailChange',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get passwordChange {
    return Intl.message(
      'Change password',
      name: 'passwordChange',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `New Version Available`
  String get versionCheckTitle {
    return Intl.message(
      'New Version Available',
      name: 'versionCheckTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please update the app to enjoy the latest features.`
  String get versionCheckContent {
    return Intl.message(
      'Please update the app to enjoy the latest features.',
      name: 'versionCheckContent',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get laterButton {
    return Intl.message(
      'Later',
      name: 'laterButton',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get updateButton {
    return Intl.message(
      'Update',
      name: 'updateButton',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: `
  String get errorMessage {
    return Intl.message(
      'An error occurred: ',
      name: 'errorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch Url`
  String get couldNotLaunch {
    return Intl.message(
      'Could not launch Url',
      name: 'couldNotLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Your Trading Accounts`
  String get accountListPageTitle {
    return Intl.message(
      'Your Trading Accounts',
      name: 'accountListPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Payments`
  String get paymentsPageTitle {
    return Intl.message(
      'Your Payments',
      name: 'paymentsPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Trades`
  String get tradesPageTitle {
    return Intl.message(
      'Your Trades',
      name: 'tradesPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `pending`
  String get pending {
    return Intl.message(
      'pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `approved`
  String get approved {
    return Intl.message(
      'approved',
      name: 'approved',
      desc: '',
      args: [],
    );
  }

  /// `rejected`
  String get rejected {
    return Intl.message(
      'rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `on_hold`
  String get onHold {
    return Intl.message(
      'on_hold',
      name: 'onHold',
      desc: '',
      args: [],
    );
  }

  /// `The current password is incorrect.`
  String get currentPasswordInvalid {
    return Intl.message(
      'The current password is incorrect.',
      name: 'currentPasswordInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a current password`
  String get enterCurrentPassword {
    return Intl.message(
      'Please enter a current password',
      name: 'enterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password should be different from the old password.`
  String get passwordNotUnique {
    return Intl.message(
      'New password should be different from the old password.',
      name: 'passwordNotUnique',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Username must be at least 2 characters long`
  String get usernameTooShort {
    return Intl.message(
      'Username must be at least 2 characters long',
      name: 'usernameTooShort',
      desc: '',
      args: [],
    );
  }

  /// `This username is already taken`
  String get usernameAlreadyTaken {
    return Intl.message(
      'This username is already taken',
      name: 'usernameAlreadyTaken',
      desc: '',
      args: [],
    );
  }

  /// `Step 1: Open your first trading account now!`
  String get stepOne {
    return Intl.message(
      'Step 1: Open your first trading account now!',
      name: 'stepOne',
      desc: '',
      args: [],
    );
  }

  /// `User successfully deleted.`
  String get successDeleteUser {
    return Intl.message(
      'User successfully deleted.',
      name: 'successDeleteUser',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account `
  String get delete {
    return Intl.message(
      'Delete Account ',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete your Account`
  String get deleteUser {
    return Intl.message(
      'Delete your Account',
      name: 'deleteUser',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your registration.`
  String get firstChatMessage {
    return Intl.message(
      'Thank you for your registration.',
      name: 'firstChatMessage',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get newChatList {
    return Intl.message(
      'Chat',
      name: 'newChatList',
      desc: '',
      args: [],
    );
  }

  /// `Email link is invalid or has expired`
  String get invalidOrExpiredErrorMessage {
    return Intl.message(
      'Email link is invalid or has expired',
      name: 'invalidOrExpiredErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, please try again`
  String get defaultErrorMessage {
    return Intl.message(
      'An error occurred, please try again',
      name: 'defaultErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `close`
  String get close {
    return Intl.message(
      'close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent to your new email address. Please check your inbox and follow the instructions to confirm your email change.`
  String get emailChangeVerificationMessage {
    return Intl.message(
      'A verification email has been sent to your new email address. Please check your inbox and follow the instructions to confirm your email change.',
      name: 'emailChangeVerificationMessage',
      desc: '',
      args: [],
    );
  }

  /// `UbaPost`
  String get appName {
    return Intl.message(
      'UbaPost',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get you {
    return Intl.message(
      'You',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friends {
    return Intl.message(
      'Friends',
      name: 'friends',
      desc: '',
      args: [],
    );
  }

  /// `Radar`
  String get radar {
    return Intl.message(
      'Radar',
      name: 'radar',
      desc: '',
      args: [],
    );
  }

  /// `karma`
  String get karma {
    return Intl.message(
      'karma',
      name: 'karma',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Create Channel`
  String get createChannel {
    return Intl.message(
      'Create Channel',
      name: 'createChannel',
      desc: '',
      args: [],
    );
  }

  /// `My Chats`
  String get myChats {
    return Intl.message(
      'My Chats',
      name: 'myChats',
      desc: '',
      args: [],
    );
  }

  /// `About Me`
  String get aboutMe {
    return Intl.message(
      'About Me',
      name: 'aboutMe',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Find Users`
  String get findUsers {
    return Intl.message(
      'Find Users',
      name: 'findUsers',
      desc: '',
      args: [],
    );
  }

  /// `Add Friend`
  String get addFriend {
    return Intl.message(
      'Add Friend',
      name: 'addFriend',
      desc: '',
      args: [],
    );
  }

  /// `Friend`
  String get friend {
    return Intl.message(
      'Friend',
      name: 'friend',
      desc: '',
      args: [],
    );
  }

  /// `Friend Request Sent.`
  String get friendRequestSent {
    return Intl.message(
      'Friend Request Sent.',
      name: 'friendRequestSent',
      desc: '',
      args: [],
    );
  }

  /// `No friends yet`
  String get noFriendsYet {
    return Intl.message(
      'No friends yet',
      name: 'noFriendsYet',
      desc: '',
      args: [],
    );
  }

  /// `Market Place`
  String get marketplace {
    return Intl.message(
      'Market Place',
      name: 'marketplace',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Electronics`
  String get electronics {
    return Intl.message(
      'Electronics',
      name: 'electronics',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get clothing {
    return Intl.message(
      'Clothing',
      name: 'clothing',
      desc: '',
      args: [],
    );
  }

  /// `Sports Goods`
  String get sportsGoods {
    return Intl.message(
      'Sports Goods',
      name: 'sportsGoods',
      desc: '',
      args: [],
    );
  }

  /// `On Sale`
  String get onSale {
    return Intl.message(
      'On Sale',
      name: 'onSale',
      desc: '',
      args: [],
    );
  }

  /// `Sold Out`
  String get soldOut {
    return Intl.message(
      'Sold Out',
      name: 'soldOut',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get addProduct {
    return Intl.message(
      'Add Product',
      name: 'addProduct',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get marketplaceFilterCategory {
    return Intl.message(
      'Category',
      name: 'marketplaceFilterCategory',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get marketplaceFilterStatus {
    return Intl.message(
      'Status',
      name: 'marketplaceFilterStatus',
      desc: '',
      args: [],
    );
  }

  /// `Product name is missing`
  String get productNameMissing {
    return Intl.message(
      'Product name is missing',
      name: 'productNameMissing',
      desc: '',
      args: [],
    );
  }

  /// `Price unknown`
  String get priceUnknown {
    return Intl.message(
      'Price unknown',
      name: 'priceUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Add a new product`
  String get addProductTooltip {
    return Intl.message(
      'Add a new product',
      name: 'addProductTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching posts`
  String get fetchPostsError {
    return Intl.message(
      'Error fetching posts',
      name: 'fetchPostsError',
      desc: '',
      args: [],
    );
  }

  /// `No posts available`
  String get noPostsAvailable {
    return Intl.message(
      'No posts available',
      name: 'noPostsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Unread`
  String get unread {
    return Intl.message(
      'Unread',
      name: 'unread',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get read {
    return Intl.message(
      'Read',
      name: 'read',
      desc: '',
      args: [],
    );
  }

  /// `Load More`
  String get loadMore {
    return Intl.message(
      'Load More',
      name: 'loadMore',
      desc: '',
      args: [],
    );
  }

  /// `No unread notifications`
  String get noUnreadNotifications {
    return Intl.message(
      'No unread notifications',
      name: 'noUnreadNotifications',
      desc: '',
      args: [],
    );
  }

  /// `No read notifications`
  String get noReadNotifications {
    return Intl.message(
      'No read notifications',
      name: 'noReadNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Notification marked as read.`
  String get notificationMarkedAsRead {
    return Intl.message(
      'Notification marked as read.',
      name: 'notificationMarkedAsRead',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching notifications`
  String get fetchNotificationsError {
    return Intl.message(
      'Error fetching notifications',
      name: 'fetchNotificationsError',
      desc: '',
      args: [],
    );
  }

  /// `Error marking notification as read`
  String get markNotificationAsReadError {
    return Intl.message(
      'Error marking notification as read',
      name: 'markNotificationAsReadError',
      desc: '',
      args: [],
    );
  }

  /// `Friend request accepted`
  String get friendRequestAccepted {
    return Intl.message(
      'Friend request accepted',
      name: 'friendRequestAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Error accepting friend request`
  String get friendRequestAcceptError {
    return Intl.message(
      'Error accepting friend request',
      name: 'friendRequestAcceptError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid sender ID or user ID`
  String get invalidSenderOrUserId {
    return Intl.message(
      'Invalid sender ID or user ID',
      name: 'invalidSenderOrUserId',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Ignore`
  String get ignore {
    return Intl.message(
      'Ignore',
      name: 'ignore',
      desc: '',
      args: [],
    );
  }

  /// `No notification content`
  String get noNotificationContent {
    return Intl.message(
      'No notification content',
      name: 'noNotificationContent',
      desc: '',
      args: [],
    );
  }

  /// `Unknown User`
  String get unknownUser {
    return Intl.message(
      'Unknown User',
      name: 'unknownUser',
      desc: '',
      args: [],
    );
  }

  /// `Font Size`
  String get fontSize {
    return Intl.message(
      'Font Size',
      name: 'fontSize',
      desc: '',
      args: [],
    );
  }

  /// `Favorite Channel`
  String get favoriteLabel {
    return Intl.message(
      'Favorite Channel',
      name: 'favoriteLabel',
      desc: '',
      args: [],
    );
  }

  /// `Chat list`
  String get chatList {
    return Intl.message(
      'Chat list',
      name: 'chatList',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Scan the QR code to add friends.`
  String get scanTheQrcode {
    return Intl.message(
      'Scan the QR code to add friends.',
      name: 'scanTheQrcode',
      desc: '',
      args: [],
    );
  }

  /// `A verification code has been sent.\nPlease enter the code.`
  String get send_verification_code {
    return Intl.message(
      'A verification code has been sent.\nPlease enter the code.',
      name: 'send_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed. Please try again.`
  String get failedAuthentication {
    return Intl.message(
      'Authentication failed. Please try again.',
      name: 'failedAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get otpLabel {
    return Intl.message(
      'Verification Code',
      name: 'otpLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 6-digit code sent to `
  String get enterCodeMessage {
    return Intl.message(
      'Enter the 6-digit code sent to ',
      name: 'enterCodeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verificationTitle {
    return Intl.message(
      'Verification',
      name: 'verificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verifyButton {
    return Intl.message(
      'Verify',
      name: 'verifyButton',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email`
  String get invalidEmailTitle {
    return Intl.message(
      'Invalid Email',
      name: 'invalidEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmailMessage {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Password`
  String get invalidPasswordTitle {
    return Intl.message(
      'Invalid Password',
      name: 'invalidPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters long and contain both letters and numbers.`
  String get invalidPasswordMessage {
    return Intl.message(
      'Password must be at least 8 characters long and contain both letters and numbers.',
      name: 'invalidPasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `A verification code has been sent to your email.`
  String get sendVerificationCode {
    return Intl.message(
      'A verification code has been sent to your email.',
      name: 'sendVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code sent to your email.`
  String get enterVerificationCode {
    return Intl.message(
      'Please enter the verification code sent to your email.',
      name: 'enterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `A verification code will be sent for password change`
  String get sendOtpEmail {
    return Intl.message(
      'A verification code will be sent for password change',
      name: 'sendOtpEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password.`
  String get enterNewPassword {
    return Intl.message(
      'Please enter a new password.',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send Verification Code`
  String get sendOtpButton {
    return Intl.message(
      'Send Verification Code',
      name: 'sendOtpButton',
      desc: '',
      args: [],
    );
  }

  /// `Update Password`
  String get updatePasswordButton {
    return Intl.message(
      'Update Password',
      name: 'updatePasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `Password Reset`
  String get title {
    return Intl.message(
      'Password Reset',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `認証コードを再送信`
  String get resendOtpButton {
    return Intl.message(
      '認証コードを再送信',
      name: 'resendOtpButton',
      desc: '',
      args: [],
    );
  }

  /// `Invalid login credentials`
  String get invalidLoginMessage {
    return Intl.message(
      'Invalid login credentials',
      name: 'invalidLoginMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get errorLabel {
    return Intl.message(
      'Error',
      name: 'errorLabel',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get successLabel {
    return Intl.message(
      'Success',
      name: 'successLabel',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message(
      'Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Unfollowed`
  String get unfollowed {
    return Intl.message(
      'Unfollowed',
      name: 'unfollowed',
      desc: '',
      args: [],
    );
  }

  /// `No followers yet`
  String get noFollowersYet {
    return Intl.message(
      'No followers yet',
      name: 'noFollowersYet',
      desc: '',
      args: [],
    );
  }

  /// `Followed`
  String get followed {
    return Intl.message(
      'Followed',
      name: 'followed',
      desc: '',
      args: [],
    );
  }

  /// `Following Users`
  String get followingUsers {
    return Intl.message(
      'Following Users',
      name: 'followingUsers',
      desc: '',
      args: [],
    );
  }

  /// `All Users`
  String get allUsers {
    return Intl.message(
      'All Users',
      name: 'allUsers',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `SMS Signup`
  String get smsSignup {
    return Intl.message(
      'SMS Signup',
      name: 'smsSignup',
      desc: '',
      args: [],
    );
  }

  /// `Verify Phone`
  String get verifyPhone {
    return Intl.message(
      'Verify Phone',
      name: 'verifyPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code.`
  String get enterOtp {
    return Intl.message(
      'Please enter the verification code.',
      name: 'enterOtp',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get otp {
    return Intl.message(
      'Verification Code',
      name: 'otp',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Verification successful!`
  String get verificationSuccess {
    return Intl.message(
      'Verification successful!',
      name: 'verificationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Verification failed. Please try again.`
  String get verificationFailed {
    return Intl.message(
      'Verification failed. Please try again.',
      name: 'verificationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number.`
  String get enterPhoneNumber {
    return Intl.message(
      'Please enter your phone number.',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number format.`
  String get invalidPhoneNumber {
    return Intl.message(
      'Invalid phone number format.',
      name: 'invalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP format.`
  String get invalidOtp {
    return Intl.message(
      'Invalid OTP format.',
      name: 'invalidOtp',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get sendCode {
    return Intl.message(
      'Send Code',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `Code Sent`
  String get codeSentTitle {
    return Intl.message(
      'Code Sent',
      name: 'codeSentTitle',
      desc: '',
      args: [],
    );
  }

  /// `A verification code has been sent to your phone.`
  String get codeSentMessage {
    return Intl.message(
      'A verification code has been sent to your phone.',
      name: 'codeSentMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please check your phone for the verification code.`
  String get codeSentInfo {
    return Intl.message(
      'Please check your phone for the verification code.',
      name: 'codeSentInfo',
      desc: '',
      args: [],
    );
  }

  /// `Verify Code`
  String get verifyCode {
    return Intl.message(
      'Verify Code',
      name: 'verifyCode',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Home Screen!`
  String get welcomeHome {
    return Intl.message(
      'Welcome to the Home Screen!',
      name: 'welcomeHome',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again.`
  String get errorOccurred {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `+81 90-1234-5678`
  String get phoneNumberHint {
    return Intl.message(
      '+81 90-1234-5678',
      name: 'phoneNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `OTP verification failed. Please try again.`
  String get otpVerificationFailedMessage {
    return Intl.message(
      'OTP verification failed. Please try again.',
      name: 'otpVerificationFailedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update username. Please try again.`
  String get usernameUpdateFailedMessage {
    return Intl.message(
      'Failed to update username. Please try again.',
      name: 'usernameUpdateFailedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Create Channel`
  String get channelCreationTitle {
    return Intl.message(
      'Create Channel',
      name: 'channelCreationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter Channel Name`
  String get channelNameLabel {
    return Intl.message(
      'Enter Channel Name',
      name: 'channelNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter Channel Description`
  String get channelDescriptionLabel {
    return Intl.message(
      'Enter Channel Description',
      name: 'channelDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Select Category`
  String get selectCategoryLabel {
    return Intl.message(
      'Select Category',
      name: 'selectCategoryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Select Prefecture`
  String get selectPrefectureLabel {
    return Intl.message(
      'Select Prefecture',
      name: 'selectPrefectureLabel',
      desc: '',
      args: [],
    );
  }

  /// `Select Channel Image`
  String get selectChannelImageLabel {
    return Intl.message(
      'Select Channel Image',
      name: 'selectChannelImageLabel',
      desc: '',
      args: [],
    );
  }

  /// `A channel with the same name already exists`
  String get channelNameExistsMessage {
    return Intl.message(
      'A channel with the same name already exists',
      name: 'channelNameExistsMessage',
      desc: '',
      args: [],
    );
  }

  /// `Creating Channel...`
  String get channelCreationInProgressMessage {
    return Intl.message(
      'Creating Channel...',
      name: 'channelCreationInProgressMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please select a category`
  String get categoryNotSelectedMessage {
    return Intl.message(
      'Please select a category',
      name: 'categoryNotSelectedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please select a prefecture`
  String get prefectureNotSelectedMessage {
    return Intl.message(
      'Please select a prefecture',
      name: 'prefectureNotSelectedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Channel created successfully`
  String get channelCreationSuccessMessage {
    return Intl.message(
      'Channel created successfully',
      name: 'channelCreationSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create channel`
  String get channelCreationFailureMessage {
    return Intl.message(
      'Failed to create channel',
      name: 'channelCreationFailureMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch categories`
  String get categoryFetchFailureMessage {
    return Intl.message(
      'Failed to fetch categories',
      name: 'categoryFetchFailureMessage',
      desc: '',
      args: [],
    );
  }

  /// `Channel updated successfully`
  String get channelUpdateSuccessMessage {
    return Intl.message(
      'Channel updated successfully',
      name: 'channelUpdateSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update channel`
  String get channelUpdateFailureMessage {
    return Intl.message(
      'Failed to update channel',
      name: 'channelUpdateFailureMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete Channel`
  String get channelDeleteTitle {
    return Intl.message(
      'Delete Channel',
      name: 'channelDeleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this channel? This action cannot be undone.`
  String get channelDeleteConfirmation {
    return Intl.message(
      'Are you sure you want to delete this channel? This action cannot be undone.',
      name: 'channelDeleteConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelLabel {
    return Intl.message(
      'Cancel',
      name: 'cancelLabel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteLabel {
    return Intl.message(
      'Delete',
      name: 'deleteLabel',
      desc: '',
      args: [],
    );
  }

  /// `Channel deleted successfully`
  String get channelDeleteSuccessMessage {
    return Intl.message(
      'Channel deleted successfully',
      name: 'channelDeleteSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete channel`
  String get channelDeleteFailureMessage {
    return Intl.message(
      'Failed to delete channel',
      name: 'channelDeleteFailureMessage',
      desc: '',
      args: [],
    );
  }

  /// `Edit Channel`
  String get editChannelTitle {
    return Intl.message(
      'Edit Channel',
      name: 'editChannelTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch channel information`
  String get channelFetchFailureMessage {
    return Intl.message(
      'Failed to fetch channel information',
      name: 'channelFetchFailureMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch prefectures`
  String get prefectureFetchFailureMessage {
    return Intl.message(
      'Failed to fetch prefectures',
      name: 'prefectureFetchFailureMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter channel name`
  String get channelNameInputLabel {
    return Intl.message(
      'Enter channel name',
      name: 'channelNameInputLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter channel description`
  String get channelDescriptionInputLabel {
    return Intl.message(
      'Enter channel description',
      name: 'channelDescriptionInputLabel',
      desc: '',
      args: [],
    );
  }

  /// `Update Channel`
  String get updateChannelButtonLabel {
    return Intl.message(
      'Update Channel',
      name: 'updateChannelButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Delete Channel`
  String get deleteChannelButtonLabel {
    return Intl.message(
      'Delete Channel',
      name: 'deleteChannelButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `'s Profile`
  String get profileTitle {
    return Intl.message(
      '\'s Profile',
      name: 'profileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching profile information`
  String get profileFetchError {
    return Intl.message(
      'Error fetching profile information',
      name: 'profileFetchError',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching friend request status`
  String get friendRequestStatusError {
    return Intl.message(
      'Error fetching friend request status',
      name: 'friendRequestStatusError',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching follow status`
  String get followStatusError {
    return Intl.message(
      'Error fetching follow status',
      name: 'followStatusError',
      desc: '',
      args: [],
    );
  }

  /// `No bio available`
  String get noBioMessage {
    return Intl.message(
      'No bio available',
      name: 'noBioMessage',
      desc: '',
      args: [],
    );
  }

  /// `Followed successfully`
  String get followSuccessMessage {
    return Intl.message(
      'Followed successfully',
      name: 'followSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unfollowed successfully`
  String get unfollowSuccessMessage {
    return Intl.message(
      'Unfollowed successfully',
      name: 'unfollowSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get followButton {
    return Intl.message(
      'Follow',
      name: 'followButton',
      desc: '',
      args: [],
    );
  }

  /// `Unfollow`
  String get unfollowButton {
    return Intl.message(
      'Unfollow',
      name: 'unfollowButton',
      desc: '',
      args: [],
    );
  }

  /// `Failed to retrieve user information`
  String get userFetchErrorMessage {
    return Intl.message(
      'Failed to retrieve user information',
      name: 'userFetchErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get mapScreenTitle {
    return Intl.message(
      'Map',
      name: 'mapScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update position`
  String get positionUpdateError {
    return Intl.message(
      'Failed to update position',
      name: 'positionUpdateError',
      desc: '',
      args: [],
    );
  }

  /// `Location services are disabled.`
  String get locationServiceDisabled {
    return Intl.message(
      'Location services are disabled.',
      name: 'locationServiceDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Location permission was denied.`
  String get locationPermissionDenied {
    return Intl.message(
      'Location permission was denied.',
      name: 'locationPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Location permission is permanently denied.`
  String get locationPermissionPermanentlyDenied {
    return Intl.message(
      'Location permission is permanently denied.',
      name: 'locationPermissionPermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Null latitude or longitude for user {0}`
  String get nullLatLngError {
    return Intl.message(
      'Null latitude or longitude for user {0}',
      name: 'nullLatLngError',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred while subscribing to location updates`
  String get locationSubscriptionError {
    return Intl.message(
      'Error occurred while subscribing to location updates',
      name: 'locationSubscriptionError',
      desc: '',
      args: [],
    );
  }

  /// `Password Reset`
  String get passwordResetTitle {
    return Intl.message(
      'Password Reset',
      name: 'passwordResetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent.`
  String get otpSentMessage {
    return Intl.message(
      'Verification code sent.',
      name: 'otpSentMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code sent to your email`
  String get enterOtpMessage {
    return Intl.message(
      'Please enter the verification code sent to your email',
      name: 'enterOtpMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sending verification code for password change`
  String get sendOtpInstruction {
    return Intl.message(
      'Sending verification code for password change',
      name: 'sendOtpInstruction',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get generalErrorMessage {
    return Intl.message(
      'An error occurred',
      name: 'generalErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to initialize chat.`
  String get chatInitError {
    return Intl.message(
      'Failed to initialize chat.',
      name: 'chatInitError',
      desc: '',
      args: [],
    );
  }

  /// `Error loading messages.`
  String get messageLoadError {
    return Intl.message(
      'Error loading messages.',
      name: 'messageLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Loading more messages before`
  String get loadingMoreMessages {
    return Intl.message(
      'Loading more messages before',
      name: 'loadingMoreMessages',
      desc: '',
      args: [],
    );
  }

  /// `Loaded {0} older messages.`
  String get loadedOlderMessages {
    return Intl.message(
      'Loaded {0} older messages.',
      name: 'loadedOlderMessages',
      desc: '',
      args: [],
    );
  }

  /// `No more messages to load.`
  String get noMoreMessages {
    return Intl.message(
      'No more messages to load.',
      name: 'noMoreMessages',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading image.`
  String get imageUploadError {
    return Intl.message(
      'Error uploading image.',
      name: 'imageUploadError',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send message.`
  String get messageSendError {
    return Intl.message(
      'Failed to send message.',
      name: 'messageSendError',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR Code`
  String get scanQrCodeTitle {
    return Intl.message(
      'Scan QR Code',
      name: 'scanQrCodeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButtonLabel {
    return Intl.message(
      'Cancel',
      name: 'cancelButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Friend added successfully!`
  String get friendAddedMessage {
    return Intl.message(
      'Friend added successfully!',
      name: 'friendAddedMessage',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while scanning`
  String get scanErrorMessage {
    return Intl.message(
      'An error occurred while scanning',
      name: 'scanErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Image uploaded successfully`
  String get imageUploadSuccess {
    return Intl.message(
      'Image uploaded successfully',
      name: 'imageUploadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Bio updated successfully`
  String get bioUpdateSuccess {
    return Intl.message(
      'Bio updated successfully',
      name: 'bioUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update bio`
  String get bioUpdateError {
    return Intl.message(
      'Failed to update bio',
      name: 'bioUpdateError',
      desc: '',
      args: [],
    );
  }

  /// `User is not logged in`
  String get userNotLoggedIn {
    return Intl.message(
      'User is not logged in',
      name: 'userNotLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Search by channel name`
  String get searchByChannelName {
    return Intl.message(
      'Search by channel name',
      name: 'searchByChannelName',
      desc: '',
      args: [],
    );
  }

  /// `All Prefectures`
  String get allPrefectures {
    return Intl.message(
      'All Prefectures',
      name: 'allPrefectures',
      desc: '',
      args: [],
    );
  }

  /// `Search by Prefecture`
  String get searchByPrefecture {
    return Intl.message(
      'Search by Prefecture',
      name: 'searchByPrefecture',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch prefectures`
  String get prefectureFetchError {
    return Intl.message(
      'Failed to fetch prefectures',
      name: 'prefectureFetchError',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch channels`
  String get fetchChannelsError {
    return Intl.message(
      'Failed to fetch channels',
      name: 'fetchChannelsError',
      desc: '',
      args: [],
    );
  }

  /// `No channels found`
  String get noChannelsFound {
    return Intl.message(
      'No channels found',
      name: 'noChannelsFound',
      desc: '',
      args: [],
    );
  }

  /// `Create Product`
  String get createProductTitle {
    return Intl.message(
      'Create Product',
      name: 'createProductTitle',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get productNameLabel {
    return Intl.message(
      'Product Name',
      name: 'productNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Product Description`
  String get productDescriptionLabel {
    return Intl.message(
      'Product Description',
      name: 'productDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get productPriceLabel {
    return Intl.message(
      'Price',
      name: 'productPriceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Select Images`
  String get selectImagesButtonText {
    return Intl.message(
      'Select Images',
      name: 'selectImagesButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Failed to upload image`
  String get imageUploadFailedMessage {
    return Intl.message(
      'Failed to upload image',
      name: 'imageUploadFailedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Product created successfully`
  String get productCreationSuccessMessage {
    return Intl.message(
      'Product created successfully',
      name: 'productCreationSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create product`
  String get productCreationFailureMessage {
    return Intl.message(
      'Failed to create product',
      name: 'productCreationFailureMessage',
      desc: '',
      args: [],
    );
  }

  /// `Create Product`
  String get createProductButtonText {
    return Intl.message(
      'Create Product',
      name: 'createProductButtonText',
      desc: '',
      args: [],
    );
  }

  /// `User is not logged in`
  String get userNotLoggedInMessage {
    return Intl.message(
      'User is not logged in',
      name: 'userNotLoggedInMessage',
      desc: '',
      args: [],
    );
  }

  /// `No favorite channels`
  String get noFavoriteChannelsMessage {
    return Intl.message(
      'No favorite channels',
      name: 'noFavoriteChannelsMessage',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboardTitle {
    return Intl.message(
      'Dashboard',
      name: 'dashboardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Not logged in`
  String get notLoggedInMessage {
    return Intl.message(
      'Not logged in',
      name: 'notLoggedInMessage',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get userProfileTitle {
    return Intl.message(
      'Profile',
      name: 'userProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please set a username`
  String get usernameSettingTitle {
    return Intl.message(
      'Please set a username',
      name: 'usernameSettingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get usernameLabel {
    return Intl.message(
      'Username',
      name: 'usernameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveButtonText {
    return Intl.message(
      'Save',
      name: 'saveButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Karma`
  String get karmaLabel {
    return Intl.message(
      'Karma',
      name: 'karmaLabel',
      desc: '',
      args: [],
    );
  }

  /// `QR Code`
  String get qrCodeLabel {
    return Intl.message(
      'QR Code',
      name: 'qrCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Create Channel`
  String get createChannelButtonText {
    return Intl.message(
      'Create Channel',
      name: 'createChannelButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Channels You Own`
  String get ownedChannelsTitle {
    return Intl.message(
      'Channels You Own',
      name: 'ownedChannelsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get channelEditButtonText {
    return Intl.message(
      'Edit',
      name: 'channelEditButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Error loading profile information`
  String get errorLoadingProfileMessage {
    return Intl.message(
      'Error loading profile information',
      name: 'errorLoadingProfileMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error loading channels`
  String get errorLoadingChannelsMessage {
    return Intl.message(
      'Error loading channels',
      name: 'errorLoadingChannelsMessage',
      desc: '',
      args: [],
    );
  }

  /// `Set Username`
  String get setUsernameTitle {
    return Intl.message(
      'Set Username',
      name: 'setUsernameTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get errorOccurredMessage {
    return Intl.message(
      'An error occurred',
      name: 'errorOccurredMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your Channels`
  String get yourChannelsLabel {
    return Intl.message(
      'Your Channels',
      name: 'yourChannelsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Fetching title...`
  String get fetchingTitleMessage {
    return Intl.message(
      'Fetching title...',
      name: 'fetchingTitleMessage',
      desc: '',
      args: [],
    );
  }

  /// `Could not fetch preview`
  String get linkPreviewError {
    return Intl.message(
      'Could not fetch preview',
      name: 'linkPreviewError',
      desc: '',
      args: [],
    );
  }

  /// `Enter the channel name`
  String get enterChannelNameHint {
    return Intl.message(
      'Enter the channel name',
      name: 'enterChannelNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter a brief description`
  String get enterChannelDescriptionHint {
    return Intl.message(
      'Enter a brief description',
      name: 'enterChannelDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Choose Image`
  String get selectImageButtonText {
    return Intl.message(
      'Choose Image',
      name: 'selectImageButtonText',
      desc: '',
      args: [],
    );
  }

  /// `投票リスト`
  String get pollListLabel {
    return Intl.message(
      '投票リスト',
      name: 'pollListLabel',
      desc: '',
      args: [],
    );
  }

  /// `投票を作成`
  String get createPollButtonText {
    return Intl.message(
      '投票を作成',
      name: 'createPollButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Edit Mode`
  String get editMode {
    return Intl.message(
      'Edit Mode',
      name: 'editMode',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a price`
  String get enterPrice {
    return Intl.message(
      'Please enter a price',
      name: 'enterPrice',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid price`
  String get invalidPrice {
    return Intl.message(
      'Please enter a valid price',
      name: 'invalidPrice',
      desc: '',
      args: [],
    );
  }

  /// `Post updated successfully`
  String get postUpdated {
    return Intl.message(
      'Post updated successfully',
      name: 'postUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update`
  String get updateFailed {
    return Intl.message(
      'Failed to update',
      name: 'updateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Bike`
  String get categoryBike {
    return Intl.message(
      'Bike',
      name: 'categoryBike',
      desc: '',
      args: [],
    );
  }

  /// `Bicycle`
  String get categoryBicycle {
    return Intl.message(
      'Bicycle',
      name: 'categoryBicycle',
      desc: '',
      args: [],
    );
  }

  /// `Wear`
  String get categoryWear {
    return Intl.message(
      'Wear',
      name: 'categoryWear',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Related`
  String get categoryDeliveryRelated {
    return Intl.message(
      'Delivery Related',
      name: 'categoryDeliveryRelated',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get categoryOther {
    return Intl.message(
      'Other',
      name: 'categoryOther',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a price.`
  String get priceRequiredMessage {
    return Intl.message(
      'Please enter a price.',
      name: 'priceRequiredMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number for the price.`
  String get invalidPriceMessage {
    return Intl.message(
      'Please enter a valid number for the price.',
      name: 'invalidPriceMessage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
