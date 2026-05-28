// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'عالم التوحد';

  @override
  String get settings => 'الإعدادات';

  @override
  String get account => 'الحساب';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get language => 'اللغة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get support => 'الدعم';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get hintEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get hintPassword => 'أدخل كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح!';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get registerHere => 'سجل هنا';

  @override
  String get joinCommunity => 'انضم إلى مجتمع عالم التوحد';

  @override
  String get createAccountDesc =>
      'أنشئ حساباً للوصول إلى الموارد والدعم المخصص.';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get hintFullName => 'أدخل اسمك الكامل';

  @override
  String get professionalDevelopment => 'التطوير المهني';

  @override
  String get psychologyAutismSupport => 'علم النفس ودعم التوحد';

  @override
  String get allEvents => 'جميع الفعاليات';

  @override
  String get mySchedule => 'جدولي';

  @override
  String get noEventsRegistered => 'لا توجد فعاليات مسجلة بعد.';

  @override
  String get seatReserved => 'تم حجز المقعد! 📅';

  @override
  String get reservationCancelled => 'تم إلغاء الحجز.';

  @override
  String get registered => 'مسجل ✓';

  @override
  String get reserveSpot => 'احجز مكان';

  @override
  String get pendingRequests => 'الطلبات المعلقة';

  @override
  String get decline => 'رفض';

  @override
  String get approve => 'قبول';

  @override
  String get allCaughtUp => 'كل شيء منتهٍ!';

  @override
  String get noPendingRequests => 'ليس لديك طلبات مواعيد معلقة.';

  @override
  String acceptedRequest(String name) {
    return 'تم قبول طلب $name';
  }

  @override
  String declinedRequest(String name) {
    return 'تم رفض طلب $name';
  }

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get approved => 'مقبول';
  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get pleaseEnterEmail => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get validEmail => 'أدخل بريداً إلكترونياً صالحاً';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور';

  @override
  String get passwordMinLength => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get pleaseEnterName => 'الرجاء إدخال اسمك';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get selectRole => 'اختر دورك';

  @override
  String get iAmA => 'أنا';

  @override
  String get parent => 'ولي أمر';

  @override
  String get specialist => 'اختصاصي';

  @override
  String get volunteer => 'متطوع';

  @override
  String get pleaseSelectRole => 'الرجاء اختيار دور';

  @override
  String get parentAccountCreated => 'تم إنشاء حساب ولي الأمر!';

  @override
  String get specialistAccountCreated => 'تم إنشاء حساب الاختصاصي!';

  @override
  String get volunteerAccountCreated => 'تم إنشاء حساب المتطوع!';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get hintDob => 'يوم/شهر/سنة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get hintPhone => 'أدخل رقم الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get hintAddress => 'أدخل عنوانك';

  @override
  String get specialization => 'الاختصاص';

  @override
  String get hintSpecialization => 'مثال: اختصاصي تخاطب';

  @override
  String get licenseNumber => 'رقم الترخيص';

  @override
  String get hintLicense => 'أدخل رقم الترخيص';

  @override
  String get volunteerType => 'نوع العمل التطوعي';

  @override
  String get hintVolunteerType => 'مثال: مساعد فعاليات، قائد ورشة عمل';

  @override
  String get thisFieldRequired => 'هذا الحقل مطلوب';

  @override
  String hello(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get workshopOverview => 'هذه هي نظرة عامة على ورش العمل الخاصة بك';

  @override
  String get total => 'الإجمالي';

  @override
  String get approvedTab => 'موافق عليه ✅';

  @override
  String get pendingTab => 'قيد الانتظار ⏳';

  @override
  String get noItemsHere => 'لا توجد عناصر هنا';

  @override
  String get addNewWorkshop => 'إضافة ورشة عمل جديدة';

  @override
  String get newWorkshopDetails => 'تفاصيل ورشة العمل الجديدة 🌟';

  @override
  String get workshopTitle => 'عنوان ورشة العمل';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get ageGroup => 'الفئة العمرية (مثال: 5-8 سنوات)';

  @override
  String get location => 'الموقع';

  @override
  String get submit => 'إرسال';

  @override
  String get allAges => 'جميع الأعمار';

  @override
  String get workshopSubmitted => 'تم إرسال ورشة العمل للموافقة!';

  @override
  String get childProfileTitle => 'ملف الطفل';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get childFullName => 'الاسم الكامل للطفل';

  @override
  String get birthDate => 'تاريخ الميلاد';

  @override
  String get gender => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get medicalProfile => 'الملف الطبي';

  @override
  String get autismLevel => 'مستوى التوحد';

  @override
  String get level1Mild => 'المستوى 1 - بسيط';

  @override
  String get level2Moderate => 'المستوى 2 - متوسط';

  @override
  String get level3Severe => 'المستوى 3 - شديد';

  @override
  String get behavioralDescription => 'الوصف السلوكي';

  @override
  String get behavioralHint =>
      'صف مختصراً المهارات الاجتماعية، الاحتياجات الحسية، إلخ.';

  @override
  String get severeCondition => 'حالة طبية خطيرة؟';

  @override
  String get specifyCondition => 'حدد الحالة (السكري، حساسية شديدة...)';

  @override
  String get saveChildProfile => 'حفظ ملف الطفل';

  @override
  String get childProfileSaved => 'تم حفظ ملف الطفل!';

  @override
  String get dailyProgressTitle => 'التقدم اليومي';

  @override
  String get howWasDay => 'كيف كان يوم طفلك؟';

  @override
  String get currentMood => 'المزاج الحالي';

  @override
  String get dailyGoals => 'الأهداف اليومية';

  @override
  String get sensoryPlay => 'أكمل اللعب الحسي';

  @override
  String get socialInteraction => 'التفاعل الاجتماعي (لعب/حديقة)';

  @override
  String get parentNotes => 'ملاحظات ولي الأمر';

  @override
  String get notesHint => 'أدخل أي محفزات أو إنجازات محددة...';

  @override
  String get saveEntry => 'حفظ الإدخال';

  @override
  String get progressSaved => 'تم حفظ التقدم!';

  @override
  String get resourcesTitle => 'موارد تعليمية';

  @override
  String get searchHint => 'ابحث عن مواضيع...';

  @override
  String get readFullArticle => 'اقرأ المقال كاملاً';

  @override
  String get eventsTitle => 'فعاليات مجتمعية';

  @override
  String get imInterested => 'أنا مهتم';

  @override
  String get interestNoted => 'تم تسجيل اهتمامك! مزيد من التفاصيل قريباً.';

  @override
  String get specialistsTitle => 'اختصاصيونا';

  @override
  String get viewComments => 'عرض تعليقات الآباء الآخرين';

  @override
  String get contactButton => 'اتصل';

  @override
  String contactFeatureComing(Object name) {
    return 'ميزة الاتصال بـ $name قريباً';
  }

  @override
  String get bookAppointmentTitle => 'حجز موعد';

  @override
  String get categoryAll => 'الكل';

  @override
  String get categorySpeechTherapist => 'اختصاصي تخاطب';

  @override
  String get categoryPsychologist => 'اختصاصي نفسي';

  @override
  String get categoryBehavioralSpecialist => 'اختصاصي سلوكي';

  @override
  String get noSpecialistsFound => 'لا يوجد اختصاصيون';

  @override
  String get bookButton => 'احجز';

  @override
  String get bookingComingSoon => 'ميزة الحجز قريباً';

  @override
  String get helloParent => 'مرحباً، ولي الأمر! 👋';

  @override
  String get dailySummary => 'هذا هو ملخصك اليومي.';

  @override
  String get upNext => 'التالي';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get childProfileSubtitle => 'انقر لإكمال أو تحديث المعلومات';

  @override
  String get menuBookAppointment => 'حجز موعد';

  @override
  String get menuSpecialists => 'الاختصاصيون';

  @override
  String get menuDailyProgress => 'التقدم اليومي';

  @override
  String get menuResources => 'الموارد';

  @override
  String get menuCommunityEvents => 'الفعاليات المجتمعية';

  @override
  String get upcomingTherapy => 'جلسة تخاطب';

  @override
  String get upcomingDoctor => 'د. سارة ويلسون';

  @override
  String get timeHour => '٤:٠٠';

  @override
  String get timePeriod => 'م';

  @override
  String get clientDetailsTitle => 'تفاصيل العميل';

  @override
  String ageYearsOld(String age) {
    return 'العمر: $age سنة';
  }

  @override
  String get diagnosisTreatment => 'التشخيص والعلاج';

  @override
  String get diagnosis => 'التشخيص';

  @override
  String get therapyType => 'نوع العلاج';

  @override
  String get sessionFrequency => 'وتيرة الجلسات';

  @override
  String get parentInfo => 'معلومات ولي الأمر';

  @override
  String get parentNameLabel => 'الاسم';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get contactParent => 'اتصال ولي الأمر';

  @override
  String get currentTreatmentGoals => 'أهداف العلاج الحالية';

  @override
  String get recentProgress => 'التقدم الأخير';

  @override
  String get importantNotes => 'ملاحظات مهمة';

  @override
  String get addNote => 'أضف ملاحظة';

  @override
  String get communityEventsSpecialistTitle => 'فعاليات مجتمعية للاختصاصيين';

  @override
  String get categoryTraining => 'تدريب';

  @override
  String get categoryPeerReview => 'مراجعة الأقران';

  @override
  String get categoryConference => 'مؤتمر';

  @override
  String get myClientsTitle => 'عملائي';

  @override
  String get lastSessionLabel => 'آخر جلسة:';

  @override
  String get nextPlanLabel => 'الخطة التالية:';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String parentPrefix(String parentName) {
    return 'ولي الأمر: $parentName';
  }

  @override
  String get pendingRequestsTitle => 'الطلبات المعلقة';

  @override
  String get noPendingAppointments => 'ليس لديك طلبات مواعيد معلقة.';

  @override
  String welcomeSpecialist(String name) {
    return 'مرحباً، د. $name!';
  }

  @override
  String appointmentsCount(String count) {
    return 'لديك $count مواعيد اليوم.';
  }

  @override
  String get upNextSpecialist => 'التالي';

  @override
  String startsInMinutes(String minutes) {
    return 'يبدأ بعد $minutes دقيقة';
  }

  @override
  String get practiceOverview => 'نظرة عامة على الممارسة';

  @override
  String get pendingRequestsButton => 'طلبات\nمعلقة';

  @override
  String get todayAppointmentsButton => 'مواعيد\nاليوم';

  @override
  String get myClientsButton => 'عملائي';

  @override
  String get communityEventsButton => 'فعاليات\nمجتمعية';

  @override
  String get badgeNew => 'جديد';

  @override
  String get badgeCheck => 'تحقق';

  @override
  String get badgeViewAll => 'عرض الكل';

  @override
  String get badgeJoin => 'انضم';

  @override
  String get upcomingAppointmentsTitle => 'المواعيد القادمة';

  @override
  String get tagTherapy => 'علاج';

  @override
  String get tagCheckup => 'فحص';

  @override
  String get tagConsultation => 'استشارة';

  @override
  String get tagFollowup => 'متابعة';
}

