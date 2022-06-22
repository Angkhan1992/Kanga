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

  /// `GET STARTED`
  String get getStarted {
    return Intl.message(
      'GET STARTED',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `OWN YOUR BALANCE`
  String get ownYourBalance {
    return Intl.message(
      'OWN YOUR BALANCE',
      name: 'ownYourBalance',
      desc: '',
      args: [],
    );
  }

  /// `EXERCISE TO STAY ON YOUR FEET\nANY WHERE, ANY TIME.`
  String get experienceToStay {
    return Intl.message(
      'EXERCISE TO STAY ON YOUR FEET\nANY WHERE, ANY TIME.',
      name: 'experienceToStay',
      desc: '',
      args: [],
    );
  }

  /// `DECREASE YOUR RISK FOR FALLS\nWITH DOCTOR APPROVED PROGRAMS`
  String get decreaseYourRisk {
    return Intl.message(
      'DECREASE YOUR RISK FOR FALLS\nWITH DOCTOR APPROVED PROGRAMS',
      name: 'decreaseYourRisk',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Strength`
  String get strength {
    return Intl.message(
      'Strength',
      name: 'strength',
      desc: '',
      args: [],
    );
  }

  /// `Mobility`
  String get mobility {
    return Intl.message(
      'Mobility',
      name: 'mobility',
      desc: '',
      args: [],
    );
  }

  /// `Take life-changing classes\nany where, any time.`
  String get takeLife {
    return Intl.message(
      'Take life-changing classes\nany where, any time.',
      name: 'takeLife',
      desc: '',
      args: [],
    );
  }

  /// `Get real-time feedback to\ncontinuously improve your balance.`
  String get getRealTime {
    return Intl.message(
      'Get real-time feedback to\ncontinuously improve your balance.',
      name: 'getRealTime',
      desc: '',
      args: [],
    );
  }

  /// `Follow on-demand classes or\nschedule a session with a certified\nKanga Specialist.`
  String get followOnDemand {
    return Intl.message(
      'Follow on-demand classes or\nschedule a session with a certified\nKanga Specialist.',
      name: 'followOnDemand',
      desc: '',
      args: [],
    );
  }

  /// `Username or Email`
  String get usernameOrEmail {
    return Intl.message(
      'Username or Email',
      name: 'usernameOrEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotYourPass {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotYourPass',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
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

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `By creating an account, you agree to our`
  String get byCreatingAccount {
    return Intl.message(
      'By creating an account, you agree to our',
      name: 'byCreatingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Terms of service`
  String get termsOfServices {
    return Intl.message(
      'Terms of service',
      name: 'termsOfServices',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message(
      'and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Membership Terms`
  String get membershipTerms {
    return Intl.message(
      'Membership Terms',
      name: 'membershipTerms',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPass {
    return Intl.message(
      'Forgot password',
      name: 'forgotPass',
      desc: '',
      args: [],
    );
  }

  /// `Email Verify`
  String get emailVerify {
    return Intl.message(
      'Email Verify',
      name: 'emailVerify',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to KangaBalance`
  String get welcomeToApp {
    return Intl.message(
      'Welcome to KangaBalance',
      name: 'welcomeToApp',
      desc: '',
      args: [],
    );
  }

  /// `We just sent a verification code to `
  String get sendVerifyCode {
    return Intl.message(
      'We just sent a verification code to ',
      name: 'sendVerifyCode',
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

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Didn't you get any code yet?`
  String get notGotCode {
    return Intl.message(
      'Didn\'t you get any code yet?',
      name: 'notGotCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend code`
  String get resendCode {
    return Intl.message(
      'Resend code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Send code`
  String get sendCode {
    return Intl.message(
      'Send code',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `Empty code`
  String get emptyCode {
    return Intl.message(
      'Empty code',
      name: 'emptyCode',
      desc: '',
      args: [],
    );
  }

  /// `Invalidate verify code`
  String get invalidCode {
    return Intl.message(
      'Invalidate verify code',
      name: 'invalidCode',
      desc: '',
      args: [],
    );
  }

  /// `Complete Profile`
  String get completeProfile {
    return Intl.message(
      'Complete Profile',
      name: 'completeProfile',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `What are your fitness goals?`
  String get fitnessGoalTitle {
    return Intl.message(
      'What are your fitness goals?',
      name: 'fitnessGoalTitle',
      desc: '',
      args: [],
    );
  }

  /// `Lose weight`
  String get fitnessGoalAnswer1 {
    return Intl.message(
      'Lose weight',
      name: 'fitnessGoalAnswer1',
      desc: '',
      args: [],
    );
  }

  /// `Build strength and muscle`
  String get fitnessGoalAnswer2 {
    return Intl.message(
      'Build strength and muscle',
      name: 'fitnessGoalAnswer2',
      desc: '',
      args: [],
    );
  }

  /// `Improve range or motion / joint mobility`
  String get fitnessGoalAnswer3 {
    return Intl.message(
      'Improve range or motion / joint mobility',
      name: 'fitnessGoalAnswer3',
      desc: '',
      args: [],
    );
  }

  /// `Better balance and coordination`
  String get fitnessGoalAnswer4 {
    return Intl.message(
      'Better balance and coordination',
      name: 'fitnessGoalAnswer4',
      desc: '',
      args: [],
    );
  }

  /// `Prevent back pain`
  String get fitnessGoalAnswer5 {
    return Intl.message(
      'Prevent back pain',
      name: 'fitnessGoalAnswer5',
      desc: '',
      args: [],
    );
  }

  /// `Boost mood and cognitive function`
  String get fitnessGoalAnswer6 {
    return Intl.message(
      'Boost mood and cognitive function',
      name: 'fitnessGoalAnswer6',
      desc: '',
      args: [],
    );
  }

  /// `Select all area of your body that you would like to focus on?`
  String get focusOnTitle {
    return Intl.message(
      'Select all area of your body that you would like to focus on?',
      name: 'focusOnTitle',
      desc: '',
      args: [],
    );
  }

  /// `Back health`
  String get focusOnAnswer1 {
    return Intl.message(
      'Back health',
      name: 'focusOnAnswer1',
      desc: '',
      args: [],
    );
  }

  /// `Knees and hips`
  String get focusOnAnswer2 {
    return Intl.message(
      'Knees and hips',
      name: 'focusOnAnswer2',
      desc: '',
      args: [],
    );
  }

  /// `Biceps`
  String get focusOnAnswer3 {
    return Intl.message(
      'Biceps',
      name: 'focusOnAnswer3',
      desc: '',
      args: [],
    );
  }

  /// `Other and none`
  String get focusOnAnswer4 {
    return Intl.message(
      'Other and none',
      name: 'focusOnAnswer4',
      desc: '',
      args: [],
    );
  }

  /// `What is your gender?`
  String get genderTitle {
    return Intl.message(
      'What is your gender?',
      name: 'genderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Find your friends`
  String get findYourFriends {
    return Intl.message(
      'Find your friends',
      name: 'findYourFriends',
      desc: '',
      args: [],
    );
  }

  /// `Add or invite friends to Kanga`
  String get addOrInviteDetail {
    return Intl.message(
      'Add or invite friends to Kanga',
      name: 'addOrInviteDetail',
      desc: '',
      args: [],
    );
  }

  /// `Copied KangaBalance Link`
  String get copyShareLink {
    return Intl.message(
      'Copied KangaBalance Link',
      name: 'copyShareLink',
      desc: '',
      args: [],
    );
  }

  /// `Measure`
  String get measure {
    return Intl.message(
      'Measure',
      name: 'measure',
      desc: '',
      args: [],
    );
  }

  /// `Classes`
  String get classes {
    return Intl.message(
      'Classes',
      name: 'classes',
      desc: '',
      args: [],
    );
  }

  /// `Coach`
  String get coach {
    return Intl.message(
      'Coach',
      name: 'coach',
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

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `On-Demand`
  String get onDemand {
    return Intl.message(
      'On-Demand',
      name: 'onDemand',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get live {
    return Intl.message(
      'Live',
      name: 'live',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Memberships`
  String get memberships {
    return Intl.message(
      'Memberships',
      name: 'memberships',
      desc: '',
      args: [],
    );
  }

  /// `Applications, Services and Devices`
  String get appServiceAndDevice {
    return Intl.message(
      'Applications, Services and Devices',
      name: 'appServiceAndDevice',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Preference`
  String get preference {
    return Intl.message(
      'Preference',
      name: 'preference',
      desc: '',
      args: [],
    );
  }

  /// `Email Notification`
  String get emailNotification {
    return Intl.message(
      'Email Notification',
      name: 'emailNotification',
      desc: '',
      args: [],
    );
  }

  /// `Push Notification`
  String get pushNotification {
    return Intl.message(
      'Push Notification',
      name: 'pushNotification',
      desc: '',
      args: [],
    );
  }

  /// `Learn More`
  String get learnMore {
    return Intl.message(
      'Learn More',
      name: 'learnMore',
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

  /// `email-already-in-use`
  String get emailAlreadyInUse {
    return Intl.message(
      'email-already-in-use',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get validName {
    return Intl.message(
      'Please enter a name',
      name: 'validName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a first name`
  String get validateFirstName {
    return Intl.message(
      'Please enter a first name',
      name: 'validateFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a last name`
  String get validateLastName {
    return Intl.message(
      'Please enter a last name',
      name: 'validateLastName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter date of birth`
  String get validateDob {
    return Intl.message(
      'Please enter date of birth',
      name: 'validateDob',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a address`
  String get validateAddress {
    return Intl.message(
      'Please enter a address',
      name: 'validateAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a city`
  String get validateCity {
    return Intl.message(
      'Please enter a city',
      name: 'validateCity',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a state`
  String get validateState {
    return Intl.message(
      'Please enter a state',
      name: 'validateState',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a email`
  String get validEmail {
    return Intl.message(
      'Please enter a email',
      name: 'validEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least 6 characters`
  String get validPassword {
    return Intl.message(
      'Please enter at least 6 characters',
      name: 'validPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least 10 numbers`
  String get validPhoneNumber {
    return Intl.message(
      'Please enter at least 10 numbers',
      name: 'validPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get emptyEmail {
    return Intl.message(
      'Please enter your email',
      name: 'emptyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get emptyPwd {
    return Intl.message(
      'Please enter your password',
      name: 'emptyPwd',
      desc: '',
      args: [],
    );
  }

  /// `This feature is not allowed yet`
  String get notAllowFeature {
    return Intl.message(
      'This feature is not allowed yet',
      name: 'notAllowFeature',
      desc: '',
      args: [],
    );
  }

  /// `Accept To Proceed`
  String get measureAlertTitle {
    return Intl.message(
      'Accept To Proceed',
      name: 'measureAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `   Kanga Measures is not a diagnostic assessment / tool. It is solely used as a reference to guide your progress with your balance and strength. If you feel like you do not have the balance and / or strength to proceed safely with doing the kanga measures, do not perform.`
  String get measureAlertMsg01 {
    return Intl.message(
      '   Kanga Measures is not a diagnostic assessment / tool. It is solely used as a reference to guide your progress with your balance and strength. If you feel like you do not have the balance and / or strength to proceed safely with doing the kanga measures, do not perform.',
      name: 'measureAlertMsg01',
      desc: '',
      args: [],
    );
  }

  /// `   With accepting this notification you are agreeing that Kanga Balance is not liable for any falls and / or injuries that occur while performing the Kanga Measures`
  String get measureAlertMsg02 {
    return Intl.message(
      '   With accepting this notification you are agreeing that Kanga Balance is not liable for any falls and / or injuries that occur while performing the Kanga Measures',
      name: 'measureAlertMsg02',
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

  /// `Join`
  String get join {
    return Intl.message(
      'Join',
      name: 'join',
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

  /// `Joined`
  String get joined {
    return Intl.message(
      'Joined',
      name: 'joined',
      desc: '',
      args: [],
    );
  }

  /// `Gain Levels`
  String get gainLevels {
    return Intl.message(
      'Gain Levels',
      name: 'gainLevels',
      desc: '',
      args: [],
    );
  }

  /// `Complete all 50 classes in each category to be promoted to a`
  String get gainLevelsAlert01 {
    return Intl.message(
      'Complete all 50 classes in each category to be promoted to a',
      name: 'gainLevelsAlert01',
      desc: '',
      args: [],
    );
  }

  /// `Superoo Mentor`
  String get gainLevelsAlert02 {
    return Intl.message(
      'Superoo Mentor',
      name: 'gainLevelsAlert02',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Fall Risk`
  String get fallRisk {
    return Intl.message(
      'Fall Risk',
      name: 'fallRisk',
      desc: '',
      args: [],
    );
  }

  /// `No. of Classes`
  String get noOfClasses {
    return Intl.message(
      'No. of Classes',
      name: 'noOfClasses',
      desc: '',
      args: [],
    );
  }

  /// `Sessions completed`
  String get sessionComplete {
    return Intl.message(
      'Sessions completed',
      name: 'sessionComplete',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Sensor Mode`
  String get sensorMode {
    return Intl.message(
      'Sensor Mode',
      name: 'sensorMode',
      desc: '',
      args: [],
    );
  }

  /// `Voice Mode`
  String get voiceMode {
    return Intl.message(
      'Voice Mode',
      name: 'voiceMode',
      desc: '',
      args: [],
    );
  }

  /// `View Score`
  String get viewScore {
    return Intl.message(
      'View Score',
      name: 'viewScore',
      desc: '',
      args: [],
    );
  }

  /// `Server Error !!!`
  String get severError {
    return Intl.message(
      'Server Error !!!',
      name: 'severError',
      desc: '',
      args: [],
    );
  }

  /// `Membership Expired`
  String get accountExpiredTitle {
    return Intl.message(
      'Membership Expired',
      name: 'accountExpiredTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your membership was already expired. Please upgrade your membership.`
  String get accountExpiredDesc1 {
    return Intl.message(
      'Your membership was already expired. Please upgrade your membership.',
      name: 'accountExpiredDesc1',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to upgrade that now?`
  String get accountExpiredDesc2 {
    return Intl.message(
      'Do you want to upgrade that now?',
      name: 'accountExpiredDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade Now`
  String get gotoMembership {
    return Intl.message(
      'Upgrade Now',
      name: 'gotoMembership',
      desc: '',
      args: [],
    );
  }

  /// `Kanga Measure`
  String get kangaMeasure {
    return Intl.message(
      'Kanga Measure',
      name: 'kangaMeasure',
      desc: '',
      args: [],
    );
  }

  /// `Your profile is not completed yet. Please complete that first.`
  String get measureRequired {
    return Intl.message(
      'Your profile is not completed yet. Please complete that first.',
      name: 'measureRequired',
      desc: '',
      args: [],
    );
  }

  /// `Sensor mode is turned OFF`
  String get sensorModeOffTitle {
    return Intl.message(
      'Sensor mode is turned OFF',
      name: 'sensorModeOffTitle',
      desc: '',
      args: [],
    );
  }

  /// `You will be using voice recognition during your Kanga Measures.`
  String get sensorModeOffDesc {
    return Intl.message(
      'You will be using voice recognition during your Kanga Measures.',
      name: 'sensorModeOffDesc',
      desc: '',
      args: [],
    );
  }

  /// `Sensor mode is turned ON`
  String get sensorModeOnTitle {
    return Intl.message(
      'Sensor mode is turned ON',
      name: 'sensorModeOnTitle',
      desc: '',
      args: [],
    );
  }

  /// `You will be using your chest strap during your Kanga Measures.`
  String get sensorModeOnDesc {
    return Intl.message(
      'You will be using your chest strap during your Kanga Measures.',
      name: 'sensorModeOnDesc',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Timer`
  String get timer {
    return Intl.message(
      'Timer',
      name: 'timer',
      desc: '',
      args: [],
    );
  }

  /// `Permission Denied`
  String get permissionDenied {
    return Intl.message(
      'Permission Denied',
      name: 'permissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `The voice recognition permission of Kanga was denied.\nYou should set the voice recognition permission to granted for voice mode measure.`
  String get permissionVoice {
    return Intl.message(
      'The voice recognition permission of Kanga was denied.\nYou should set the voice recognition permission to granted for voice mode measure.',
      name: 'permissionVoice',
      desc: '',
      args: [],
    );
  }

  /// `You can see that on 'Settings/Kanga/permissions'.`
  String get permissionHint {
    return Intl.message(
      'You can see that on \'Settings/Kanga/permissions\'.',
      name: 'permissionHint',
      desc: '',
      args: [],
    );
  }

  /// `Great Job!`
  String get greatJob {
    return Intl.message(
      'Great Job!',
      name: 'greatJob',
      desc: '',
      args: [],
    );
  }

  /// `You have completed your SINGLE LEG BALANCE.`
  String get completeSingleLeg {
    return Intl.message(
      'You have completed your SINGLE LEG BALANCE.',
      name: 'completeSingleLeg',
      desc: '',
      args: [],
    );
  }

  /// `You have completed your SIT TO STANDS.`
  String get completeSitStand {
    return Intl.message(
      'You have completed your SIT TO STANDS.',
      name: 'completeSitStand',
      desc: '',
      args: [],
    );
  }

  /// `You have completed your 10-METER WALK.`
  String get completeTenWalker {
    return Intl.message(
      'You have completed your 10-METER WALK.',
      name: 'completeTenWalker',
      desc: '',
      args: [],
    );
  }

  /// `Your result data is empty.`
  String get emptyResult {
    return Intl.message(
      'Your result data is empty.',
      name: 'emptyResult',
      desc: '',
      args: [],
    );
  }

  /// `Place phone in the chest strap horizontally facing your body.`
  String get placePhoneDescription {
    return Intl.message(
      'Place phone in the chest strap horizontally facing your body.',
      name: 'placePhoneDescription',
      desc: '',
      args: [],
    );
  }

  /// `During the downcount, stand still`
  String get downcountStandStill {
    return Intl.message(
      'During the downcount, stand still',
      name: 'downcountStandStill',
      desc: '',
      args: [],
    );
  }

  /// `Once the countdown ends, stand on your RIGHT LEG.`
  String get afterDowncountDescRightLeg {
    return Intl.message(
      'Once the countdown ends, stand on your RIGHT LEG.',
      name: 'afterDowncountDescRightLeg',
      desc: '',
      args: [],
    );
  }

  /// `You will repeat this three times on each Leg`
  String get singleLegOptionalDesc {
    return Intl.message(
      'You will repeat this three times on each Leg',
      name: 'singleLegOptionalDesc',
      desc: '',
      args: [],
    );
  }

  /// `Right Leg`
  String get rightLeg {
    return Intl.message(
      'Right Leg',
      name: 'rightLeg',
      desc: '',
      args: [],
    );
  }

  /// `Left Leg`
  String get leftLeg {
    return Intl.message(
      'Left Leg',
      name: 'leftLeg',
      desc: '',
      args: [],
    );
  }

  /// `Go Back`
  String get goBack {
    return Intl.message(
      'Go Back',
      name: 'goBack',
      desc: '',
      args: [],
    );
  }

  /// `Single leg balance`
  String get singleLegBalance {
    return Intl.message(
      'Single leg balance',
      name: 'singleLegBalance',
      desc: '',
      args: [],
    );
  }

  /// `SIT TO STANDS`
  String get sitToStand {
    return Intl.message(
      'SIT TO STANDS',
      name: 'sitToStand',
      desc: '',
      args: [],
    );
  }

  /// `Once the countdown ends, start your SIT TO STANDS.`
  String get onceDowncountStartSittoStands {
    return Intl.message(
      'Once the countdown ends, start your SIT TO STANDS.',
      name: 'onceDowncountStartSittoStands',
      desc: '',
      args: [],
    );
  }

  /// `Sit to Stands Counter`
  String get sitToStandCounter {
    return Intl.message(
      'Sit to Stands Counter',
      name: 'sitToStandCounter',
      desc: '',
      args: [],
    );
  }

  /// `10-METER WALK`
  String get tenMeterWalk {
    return Intl.message(
      '10-METER WALK',
      name: 'tenMeterWalk',
      desc: '',
      args: [],
    );
  }

  /// `Once the countdown ends, start your 10-METER WALK.`
  String get onceDowncountStartTenMeterWalk {
    return Intl.message(
      'Once the countdown ends, start your 10-METER WALK.',
      name: 'onceDowncountStartTenMeterWalk',
      desc: '',
      args: [],
    );
  }

  /// `Walk Time`
  String get walkTime {
    return Intl.message(
      'Walk Time',
      name: 'walkTime',
      desc: '',
      args: [],
    );
  }

  /// `NOT AT RISK FOR FALLS`
  String get notAtRisk {
    return Intl.message(
      'NOT AT RISK FOR FALLS',
      name: 'notAtRisk',
      desc: '',
      args: [],
    );
  }

  /// `HIGH RISK FOR FALLS`
  String get highRisk {
    return Intl.message(
      'HIGH RISK FOR FALLS',
      name: 'highRisk',
      desc: '',
      args: [],
    );
  }

  /// `MEDIUM RISK FOR FALLS`
  String get mediumRisk {
    return Intl.message(
      'MEDIUM RISK FOR FALLS',
      name: 'mediumRisk',
      desc: '',
      args: [],
    );
  }

  /// `LOW RISK FOR FALLS`
  String get lowRisk {
    return Intl.message(
      'LOW RISK FOR FALLS',
      name: 'lowRisk',
      desc: '',
      args: [],
    );
  }

  /// `RISK FOR FALLS`
  String get riskForFalls {
    return Intl.message(
      'RISK FOR FALLS',
      name: 'riskForFalls',
      desc: '',
      args: [],
    );
  }

  /// `Sec`
  String get sec {
    return Intl.message(
      'Sec',
      name: 'sec',
      desc: '',
      args: [],
    );
  }

  /// `Right`
  String get right {
    return Intl.message(
      'Right',
      name: 'right',
      desc: '',
      args: [],
    );
  }

  /// `Left`
  String get left {
    return Intl.message(
      'Left',
      name: 'left',
      desc: '',
      args: [],
    );
  }

  /// `avg. of three trials in seconds`
  String get avgOfThreeTrials {
    return Intl.message(
      'avg. of three trials in seconds',
      name: 'avgOfThreeTrials',
      desc: '',
      args: [],
    );
  }

  /// `Compared to normative data`
  String get compareToData {
    return Intl.message(
      'Compared to normative data',
      name: 'compareToData',
      desc: '',
      args: [],
    );
  }

  /// `You are average`
  String get youAreAverage {
    return Intl.message(
      'You are average',
      name: 'youAreAverage',
      desc: '',
      args: [],
    );
  }

  /// `of Sit to Stands in 30 seconds`
  String get ofSitToStand30 {
    return Intl.message(
      'of Sit to Stands in 30 seconds',
      name: 'ofSitToStand30',
      desc: '',
      args: [],
    );
  }

  /// `One month Average`
  String get oneMonthAverage {
    return Intl.message(
      'One month Average',
      name: 'oneMonthAverage',
      desc: '',
      args: [],
    );
  }

  /// `Select Month`
  String get selectMonth {
    return Intl.message(
      'Select Month',
      name: 'selectMonth',
      desc: '',
      args: [],
    );
  }

  /// `Repeat times`
  String get repeatTimes {
    return Intl.message(
      'Repeat times',
      name: 'repeatTimes',
      desc: '',
      args: [],
    );
  }

  /// `Velocity`
  String get velocity {
    return Intl.message(
      'Velocity',
      name: 'velocity',
      desc: '',
      args: [],
    );
  }

  /// `Total time balanced on each leg (in seconds)`
  String get totalTimeBalanced {
    return Intl.message(
      'Total time balanced on each leg (in seconds)',
      name: 'totalTimeBalanced',
      desc: '',
      args: [],
    );
  }

  /// `Measure static postural and balance control.`
  String get balanceControl {
    return Intl.message(
      'Measure static postural and balance control.',
      name: 'balanceControl',
      desc: '',
      args: [],
    );
  }

  /// `Total sit to stands in 30 seconds`
  String get totalSitToStands {
    return Intl.message(
      'Total sit to stands in 30 seconds',
      name: 'totalSitToStands',
      desc: '',
      args: [],
    );
  }

  /// `Measure functional lower extremity strength, transitional movements, and balance.`
  String get standsControl {
    return Intl.message(
      'Measure functional lower extremity strength, transitional movements, and balance.',
      name: 'standsControl',
      desc: '',
      args: [],
    );
  }

  /// `Time it to took complete 10-meter meters`
  String get tenMeterTime {
    return Intl.message(
      'Time it to took complete 10-meter meters',
      name: 'tenMeterTime',
      desc: '',
      args: [],
    );
  }

  /// `Measure walking speed in meters/second (m/s) over 10 meters.`
  String get tenMeterControl {
    return Intl.message(
      'Measure walking speed in meters/second (m/s) over 10 meters.',
      name: 'tenMeterControl',
      desc: '',
      args: [],
    );
  }

  /// `The measure data is empty. After measure, please try again.`
  String get measureDataEmpty {
    return Intl.message(
      'The measure data is empty. After measure, please try again.',
      name: 'measureDataEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Share Result`
  String get shareResult {
    return Intl.message(
      'Share Result',
      name: 'shareResult',
      desc: '',
      args: [],
    );
  }

  /// `You maybe measure today balance.`
  String get kangaMeasureDetail {
    return Intl.message(
      'You maybe measure today balance.',
      name: 'kangaMeasureDetail',
      desc: '',
      args: [],
    );
  }

  /// `Class(es)`
  String get class_es {
    return Intl.message(
      'Class(es)',
      name: 'class_es',
      desc: '',
      args: [],
    );
  }

  /// `Failed a social account sign, Please use other way or account`
  String get errorSocialSign {
    return Intl.message(
      'Failed a social account sign, Please use other way or account',
      name: 'errorSocialSign',
      desc: '',
      args: [],
    );
  }

  /// `Class Detail`
  String get class_detail {
    return Intl.message(
      'Class Detail',
      name: 'class_detail',
      desc: '',
      args: [],
    );
  }

  /// `Add To Favorite`
  String get addToFavorite {
    return Intl.message(
      'Add To Favorite',
      name: 'addToFavorite',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Ratings`
  String get ratings {
    return Intl.message(
      'Ratings',
      name: 'ratings',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty`
  String get difficulty {
    return Intl.message(
      'Difficulty',
      name: 'difficulty',
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

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `You just finished one class course`
  String get justFinishOneClass {
    return Intl.message(
      'You just finished one class course',
      name: 'justFinishOneClass',
      desc: '',
      args: [],
    );
  }

  /// `Member Since`
  String get memberSince {
    return Intl.message(
      'Member Since',
      name: 'memberSince',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get level {
    return Intl.message(
      'Level',
      name: 'level',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Enter your city`
  String get enterYourCity {
    return Intl.message(
      'Enter your city',
      name: 'enterYourCity',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Select state`
  String get selectState {
    return Intl.message(
      'Select state',
      name: 'selectState',
      desc: '',
      args: [],
    );
  }

  /// `Choose Method`
  String get chooseMethod {
    return Intl.message(
      'Choose Method',
      name: 'chooseMethod',
      desc: '',
      args: [],
    );
  }

  /// `Please choose your photo library\nFrom Gallery\nFrom Camera`
  String get chooseMethodDetail {
    return Intl.message(
      'Please choose your photo library\nFrom Gallery\nFrom Camera',
      name: 'chooseMethodDetail',
      desc: '',
      args: [],
    );
  }

  /// `From Gallery`
  String get fromGallery {
    return Intl.message(
      'From Gallery',
      name: 'fromGallery',
      desc: '',
      args: [],
    );
  }

  /// `From Camera`
  String get fromCamera {
    return Intl.message(
      'From Camera',
      name: 'fromCamera',
      desc: '',
      args: [],
    );
  }

  /// `Success updated your profile`
  String get successUpdateProfile {
    return Intl.message(
      'Success updated your profile',
      name: 'successUpdateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Image`
  String get unknownImage {
    return Intl.message(
      'Unknown Image',
      name: 'unknownImage',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Video`
  String get unknownVideo {
    return Intl.message(
      'Unknown Video',
      name: 'unknownVideo',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin {
    return Intl.message(
      'Admin',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// `Empty chat content`
  String get emptyChat {
    return Intl.message(
      'Empty chat content',
      name: 'emptyChat',
      desc: '',
      args: [],
    );
  }

  /// `Failed Social Login`
  String get failedSocialLogin {
    return Intl.message(
      'Failed Social Login',
      name: 'failedSocialLogin',
      desc: '',
      args: [],
    );
  }

  /// `Not Available`
  String get notAvailable {
    return Intl.message(
      'Not Available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Your membership was upgrade successfully`
  String get successMembership {
    return Intl.message(
      'Your membership was upgrade successfully',
      name: 'successMembership',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get second {
    return Intl.message(
      'Second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `Times`
  String get times {
    return Intl.message(
      'Times',
      name: 'times',
      desc: '',
      args: [],
    );
  }

  /// `Meter / Second`
  String get meterSecond {
    return Intl.message(
      'Meter / Second',
      name: 'meterSecond',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password`
  String get enterNewPassword {
    return Intl.message(
      'Please enter a new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your account password was updated successfully. You can try to login again with a new password. Thanks.`
  String get changePassDesc {
    return Intl.message(
      'Your account password was updated successfully. You can try to login again with a new password. Thanks.',
      name: 'changePassDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your account email`
  String get enterForgotEmail {
    return Intl.message(
      'Please enter your account email',
      name: 'enterForgotEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please give some feedback to KangaBalance`
  String get giveMeFeedback {
    return Intl.message(
      'Please give some feedback to KangaBalance',
      name: 'giveMeFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Empty Feedback`
  String get emptyFeedback {
    return Intl.message(
      'Empty Feedback',
      name: 'emptyFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Your feedback was sent to KangaBalance successfully`
  String get successFeedback {
    return Intl.message(
      'Your feedback was sent to KangaBalance successfully',
      name: 'successFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Expired Date`
  String get expiredDate {
    return Intl.message(
      'Expired Date',
      name: 'expiredDate',
      desc: '',
      args: [],
    );
  }

  /// `Reserve`
  String get reverse {
    return Intl.message(
      'Reserve',
      name: 'reverse',
      desc: '',
      args: [],
    );
  }

  /// `LiveStream`
  String get liveStream {
    return Intl.message(
      'LiveStream',
      name: 'liveStream',
      desc: '',
      args: [],
    );
  }

  /// `Live Stream Detail`
  String get liveStreamDetail {
    return Intl.message(
      'Live Stream Detail',
      name: 'liveStreamDetail',
      desc: '',
      args: [],
    );
  }

  /// `Link`
  String get link {
    return Intl.message(
      'Link',
      name: 'link',
      desc: '',
      args: [],
    );
  }

  /// `ID`
  String get id {
    return Intl.message(
      'ID',
      name: 'id',
      desc: '',
      args: [],
    );
  }

  /// `Passcode`
  String get passcode {
    return Intl.message(
      'Passcode',
      name: 'passcode',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get invite {
    return Intl.message(
      'Invite',
      name: 'invite',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Added calendar successfully`
  String get addCalendarSuccess {
    return Intl.message(
      'Added calendar successfully',
      name: 'addCalendarSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Tell us how you're doing today`
  String get tellUsHow {
    return Intl.message(
      'Tell us how you\'re doing today',
      name: 'tellUsHow',
      desc: '',
      args: [],
    );
  }

  /// `How do you feel today? (Pick one)`
  String get howFeelToday {
    return Intl.message(
      'How do you feel today? (Pick one)',
      name: 'howFeelToday',
      desc: '',
      args: [],
    );
  }

  /// `Depressed`
  String get depressed {
    return Intl.message(
      'Depressed',
      name: 'depressed',
      desc: '',
      args: [],
    );
  }

  /// `Sad`
  String get sad {
    return Intl.message(
      'Sad',
      name: 'sad',
      desc: '',
      args: [],
    );
  }

  /// `Happy`
  String get happy {
    return Intl.message(
      'Happy',
      name: 'happy',
      desc: '',
      args: [],
    );
  }

  /// `Very Happy`
  String get veryHappy {
    return Intl.message(
      'Very Happy',
      name: 'veryHappy',
      desc: '',
      args: [],
    );
  }

  /// `Any other comments?`
  String get anyOtherComments {
    return Intl.message(
      'Any other comments?',
      name: 'anyOtherComments',
      desc: '',
      args: [],
    );
  }

  /// `Are you feeling discomfort?\nWhere?\nHow can we make Kanga Balance better suit your needs?`
  String get anyOtherHint {
    return Intl.message(
      'Are you feeling discomfort?\nWhere?\nHow can we make Kanga Balance better suit your needs?',
      name: 'anyOtherHint',
      desc: '',
      args: [],
    );
  }

  /// `Success submitted!!`
  String get successSubmit {
    return Intl.message(
      'Success submitted!!',
      name: 'successSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Completed Profile`
  String get notCorrectUserInfo {
    return Intl.message(
      'Completed Profile',
      name: 'notCorrectUserInfo',
      desc: '',
      args: [],
    );
  }

  /// `Results will not be accurate if you proceed without completing your profile.`
  String get notCorrectWrongDetail {
    return Intl.message(
      'Results will not be accurate if you proceed without completing your profile.',
      name: 'notCorrectWrongDetail',
      desc: '',
      args: [],
    );
  }

  /// `Complete Now`
  String get completeNow {
    return Intl.message(
      'Complete Now',
      name: 'completeNow',
      desc: '',
      args: [],
    );
  }

  /// `Invite Friend`
  String get inviteFriend {
    return Intl.message(
      'Invite Friend',
      name: 'inviteFriend',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get contacts {
    return Intl.message(
      'Contacts',
      name: 'contacts',
      desc: '',
      args: [],
    );
  }

  /// `Empty List!!!`
  String get emptyList {
    return Intl.message(
      'Empty List!!!',
      name: 'emptyList',
      desc: '',
      args: [],
    );
  }

  /// `Search Key ...`
  String get searchKey {
    return Intl.message(
      'Search Key ...',
      name: 'searchKey',
      desc: '',
      args: [],
    );
  }

  /// `You should select at least one contact`
  String get noSelectContact {
    return Intl.message(
      'You should select at least one contact',
      name: 'noSelectContact',
      desc: '',
      args: [],
    );
  }

  /// `Sent Invitations Successfully!!!`
  String get sentInvitationSuccess {
    return Intl.message(
      'Sent Invitations Successfully!!!',
      name: 'sentInvitationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Premium\nMember`
  String get premiumMember {
    return Intl.message(
      'Premium\nMember',
      name: 'premiumMember',
      desc: '',
      args: [],
    );
  }

  /// `Expired\nMembership`
  String get overExpiredDate {
    return Intl.message(
      'Expired\nMembership',
      name: 'overExpiredDate',
      desc: '',
      args: [],
    );
  }

  /// `Your subscription was expired!!!`
  String get expiredSubscription {
    return Intl.message(
      'Your subscription was expired!!!',
      name: 'expiredSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Can't open this link`
  String get notOpenLink {
    return Intl.message(
      'Can\'t open this link',
      name: 'notOpenLink',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Achievements`
  String get achievements {
    return Intl.message(
      'Achievements',
      name: 'achievements',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get seeAll {
    return Intl.message(
      'See all',
      name: 'seeAll',
      desc: '',
      args: [],
    );
  }

  /// `Not Award Yet`
  String get notAwardYet {
    return Intl.message(
      'Not Award Yet',
      name: 'notAwardYet',
      desc: '',
      args: [],
    );
  }

  /// `Join me on Kanga Balance! Access your strength and balance, exercise with on-demand classes and join the fun with live sessions!`
  String get shareAppContent {
    return Intl.message(
      'Join me on Kanga Balance! Access your strength and balance, exercise with on-demand classes and join the fun with live sessions!',
      name: 'shareAppContent',
      desc: '',
      args: [],
    );
  }

  /// `KangaBalance`
  String get kangaBalance {
    return Intl.message(
      'KangaBalance',
      name: 'kangaBalance',
      desc: '',
      args: [],
    );
  }

  /// `Share chest straps link`
  String get chestLink {
    return Intl.message(
      'Share chest straps link',
      name: 'chestLink',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get login {
    return Intl.message(
      'Log In',
      name: 'login',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
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
