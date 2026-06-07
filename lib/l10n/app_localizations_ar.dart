// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settings => 'الأعدادات';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get medicationReminders => 'تذكيرات الدواء';

  @override
  String get refillReminder => 'تذكير إعادة الملء';

  @override
  String get missedMedicationAlerts => 'تنبيهات الأدوية الفائتة';

  @override
  String get snoozeOptions => 'خيارات الغفوة';

  @override
  String get minutes => 'دقائق';

  @override
  String get general => 'عام';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get darkTheme => 'الوضع الليلي';

  @override
  String get account => 'الحساب';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinPillSync => 'انضم إلى PillSYNC وقم بإدارة أدويتك';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterFullName => 'أدخل اسمك الكامل';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور الخاصة بك';

  @override
  String get createPassword => 'أنشئ كلمة مرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmYourPassword => 'أكد كلمة المرور الخاصة بك';

  @override
  String get agreeTerms => 'أنا أوافق على الشروط والأحكام وسياسة الخصوصية';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب بالفعل؟ ';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get orSignUpWith => 'أو قم بالتسجيل بواسطة';

  @override
  String get google => 'جوجل';

  @override
  String get apple => 'أبل';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get pleaseAgreeTerms => 'يرجى الموافقة على الشروط والأحكام للمتابعة';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToContinue => 'سجل الدخول للمتابعة في PillSYNC';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get orContinueWith => 'أو استمر بواسطة';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني لاستلام رمز التحقق';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get enterOtp => 'أدخل رمز التحقق';

  @override
  String get weSentCodeTo => 'لقد أرسلنا رمزاً إلى';

  @override
  String get enterSixDigitCode => 'أدخل الرمز المكون من 6 أرقام';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get verifyOtp => 'تحقق من الرمز';

  @override
  String get goodMorning => 'صباح الخير،';

  @override
  String get nextMedicine => 'الدواء القادم';

  @override
  String get todayAt => 'اليوم في';

  @override
  String get healthTipTitle => 'نصيحة اليوم الصحية';

  @override
  String get healthTipContent =>
      'حافظ على رطوبتك! شرب الماء يمكن أن يساعد في امتصاص الدواء.';

  @override
  String get overallAdherence => 'نسبة الالتزام العامة';

  @override
  String get greatJob => 'عمل رائع هذا الأسبوع!';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get mySchedule => 'جدولي';

  @override
  String get viewReports => 'عرض التقارير';

  @override
  String get findPharmacy => 'ابحث عن صيدلية';

  @override
  String get home => 'الرئيسية';

  @override
  String get meds => 'الأدوية';

  @override
  String get add => 'إضافة';

  @override
  String get reports => 'التقارير';

  @override
  String get missedMedicationTitle => 'دواء فائت';

  @override
  String get missedMedicationSubtitle => 'لم تقم بتناول هذه الأدوية اليوم';

  @override
  String get takeLater => 'سآخذه لاحقاً';

  @override
  String get mymedications => 'دوائي';

  @override
  String get nextDose => 'الجرعة القادمة:';

  @override
  String inMinutes(Object minutes) {
    return 'خلال $minutes دقيقة';
  }

  @override
  String get takeNow => 'تناول الآن';

  @override
  String get snooze => 'غفوة';

  @override
  String get todaySchedule => 'جدول اليوم';

  @override
  String get taken => 'تم تناوله';

  @override
  String get markAsTaken => 'تحديد كمكتمل';

  @override
  String get addMedicationMethod => 'كيف تود إضافة الدواء الخاص بك؟';

  @override
  String get scanPrescription => 'مسح علبة الدواء ضوئياً';

  @override
  String get useCameraScan => 'استخدم الكاميرا لمسح علبة الدواء الخاصة بك';

  @override
  String get enterDetailsManually => 'إدخال التفاصيل يدوياً';

  @override
  String get manuallyEnterDetails => 'أدخل تفاصيل الدواء يدوياً';

  @override
  String get scanYourPrescription => 'امسح علبة الدواء ضوئياً';

  @override
  String get placePrescriptionFrame =>
      'ضع علبة الدواء داخل الإطار وثبتها جيداً';

  @override
  String get retake => 'إعادة التقاط';

  @override
  String get gallery => 'المعرض';

  @override
  String get medicationName => 'اسم الدواء';

  @override
  String get dosage => 'الجرعة';

  @override
  String get typeOfDrug => 'نوع الدواء';

  @override
  String get frequency => 'التكرار';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get selecttime => 'اختر الوقت';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get timeToTakeMedicine => 'وقت تناول الدواء';

  @override
  String get instructions => 'تعليمات (اختياري)';

  @override
  String get egLisinopril => 'مثال: ليسينوبريل';

  @override
  String get egDosage => 'مثال: 25 ملجم';

  @override
  String get egInstructions => 'مثال: تناوله مع الطعام';

  @override
  String get medicineTablets => 'أقراص دواء';

  @override
  String get capsule => 'كبسولة';

  @override
  String get syrup => 'شراب';

  @override
  String get oncedaily => 'مرة يومياً';

  @override
  String get twicedaily => 'مرتين يومياً';

  @override
  String get threedaily => 'ثلاث مرات يومياً';
}
