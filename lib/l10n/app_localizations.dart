import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @medicationReminders.
  ///
  /// In en, this message translates to:
  /// **'Medication Reminders'**
  String get medicationReminders;

  /// No description provided for @refillReminder.
  ///
  /// In en, this message translates to:
  /// **'Refill Reminder'**
  String get refillReminder;

  /// No description provided for @missedMedicationAlerts.
  ///
  /// In en, this message translates to:
  /// **'Missed Medication Alerts'**
  String get missedMedicationAlerts;

  /// No description provided for @snoozeOptions.
  ///
  /// In en, this message translates to:
  /// **'Snooze Options'**
  String get snoozeOptions;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinPillSync.
  ///
  /// In en, this message translates to:
  /// **'Join PillSYNC and manage your medications'**
  String get joinPillSync;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms & Conditions and Privacy Policy'**
  String get agreeTerms;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @orSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign up with'**
  String get orSignUpWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @pleaseAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms and conditions to continue'**
  String get pleaseAgreeTerms;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to PillSYNC'**
  String get signInToContinue;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a verification code'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @weSentCodeTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to'**
  String get weSentCodeTo;

  /// No description provided for @enterSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get enterSixDigitCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get goodMorning;

  /// No description provided for @nextMedicine.
  ///
  /// In en, this message translates to:
  /// **'Next Medicine'**
  String get nextMedicine;

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'Today at'**
  String get todayAt;

  /// No description provided for @healthTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Tip of the Day'**
  String get healthTipTitle;

  /// No description provided for @healthTipContent.
  ///
  /// In en, this message translates to:
  /// **'Stay hydrated! Drinking water can help with medication absorption.'**
  String get healthTipContent;

  /// No description provided for @overallAdherence.
  ///
  /// In en, this message translates to:
  /// **'Overall Adherence'**
  String get overallAdherence;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job this week!'**
  String get greatJob;

  /// No description provided for @addMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// No description provided for @mySchedule.
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get mySchedule;

  /// No description provided for @viewReports.
  ///
  /// In en, this message translates to:
  /// **'View Reports'**
  String get viewReports;

  /// No description provided for @findPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Find Pharmacy'**
  String get findPharmacy;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @meds.
  ///
  /// In en, this message translates to:
  /// **'Meds'**
  String get meds;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reports;

  /// No description provided for @missedMedicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Missed Medication'**
  String get missedMedicationTitle;

  /// No description provided for @missedMedicationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t taken these medications today'**
  String get missedMedicationSubtitle;

  /// No description provided for @takeLater.
  ///
  /// In en, this message translates to:
  /// **'I\'ll Take It Later'**
  String get takeLater;

  /// No description provided for @mymedications.
  ///
  /// In en, this message translates to:
  /// **'My Medications'**
  String get mymedications;

  /// No description provided for @nextDose.
  ///
  /// In en, this message translates to:
  /// **'Next dose:'**
  String get nextDose;

  /// No description provided for @inMinutes.
  ///
  /// In en, this message translates to:
  /// **'in {minutes} minutes'**
  String inMinutes(Object minutes);

  /// No description provided for @takeNow.
  ///
  /// In en, this message translates to:
  /// **'Take Now'**
  String get takeNow;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// No description provided for @todaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaySchedule;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// No description provided for @markAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark as Taken'**
  String get markAsTaken;

  /// No description provided for @addMedicationMethod.
  ///
  /// In en, this message translates to:
  /// **'How would you like to add your medication?'**
  String get addMedicationMethod;

  /// No description provided for @scanPrescription.
  ///
  /// In en, this message translates to:
  /// **'Scan Prescription'**
  String get scanPrescription;

  /// No description provided for @useCameraScan.
  ///
  /// In en, this message translates to:
  /// **'Use your camera to scan your prescription'**
  String get useCameraScan;

  /// No description provided for @enterDetailsManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Details Manually'**
  String get enterDetailsManually;

  /// No description provided for @manuallyEnterDetails.
  ///
  /// In en, this message translates to:
  /// **'Manually enter medication details'**
  String get manuallyEnterDetails;

  /// No description provided for @scanYourPrescription.
  ///
  /// In en, this message translates to:
  /// **'Scan your prescription'**
  String get scanYourPrescription;

  /// No description provided for @placePrescriptionFrame.
  ///
  /// In en, this message translates to:
  /// **'Place your prescription within the frame and hold steady.'**
  String get placePrescriptionFrame;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @typeOfDrug.
  ///
  /// In en, this message translates to:
  /// **'Type of Drug'**
  String get typeOfDrug;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selecttime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selecttime;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @timeToTakeMedicine.
  ///
  /// In en, this message translates to:
  /// **'Time to Take Medicine'**
  String get timeToTakeMedicine;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions (optional)'**
  String get instructions;

  /// No description provided for @egLisinopril.
  ///
  /// In en, this message translates to:
  /// **'e.g., Lisinopril'**
  String get egLisinopril;

  /// No description provided for @egDosage.
  ///
  /// In en, this message translates to:
  /// **'e.g., 25mg'**
  String get egDosage;

  /// No description provided for @egInstructions.
  ///
  /// In en, this message translates to:
  /// **'e.g., Take with food'**
  String get egInstructions;

  /// No description provided for @medicineTablets.
  ///
  /// In en, this message translates to:
  /// **'Medicine Tablets'**
  String get medicineTablets;

  /// No description provided for @capsule.
  ///
  /// In en, this message translates to:
  /// **'Capsule'**
  String get capsule;

  /// No description provided for @syrup.
  ///
  /// In en, this message translates to:
  /// **'ٍSyrup'**
  String get syrup;

  /// No description provided for @oncedaily.
  ///
  /// In en, this message translates to:
  /// **'Once Daily'**
  String get oncedaily;

  /// No description provided for @twicedaily.
  ///
  /// In en, this message translates to:
  /// **'Twice Daily'**
  String get twicedaily;

  /// No description provided for @threedaily.
  ///
  /// In en, this message translates to:
  /// **'Three Daily'**
  String get threedaily;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
