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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Autism World'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get hintEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @hintPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get hintPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @registerHere.
  ///
  /// In en, this message translates to:
  /// **'Register here'**
  String get registerHere;

  /// No description provided for @joinCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join the Autism World Community'**
  String get joinCommunity;

  /// No description provided for @createAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Create an account to access personalized resources and support.'**
  String get createAccountDesc;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @hintFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get hintFullName;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get pleaseEnterEmail;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select your role'**
  String get selectRole;

  /// No description provided for @iAmA.
  ///
  /// In en, this message translates to:
  /// **'I am a'**
  String get iAmA;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @specialist.
  ///
  /// In en, this message translates to:
  /// **'Specialist'**
  String get specialist;

  /// No description provided for @volunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get volunteer;

  /// No description provided for @pleaseSelectRole.
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get pleaseSelectRole;

  /// No description provided for @parentAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Parent account created!'**
  String get parentAccountCreated;

  /// No description provided for @specialistAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Specialist account created!'**
  String get specialistAccountCreated;

  /// No description provided for @volunteerAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Volunteer account created!'**
  String get volunteerAccountCreated;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @hintDob.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get hintDob;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @hintPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get hintPhone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @hintAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get hintAddress;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @hintSpecialization.
  ///
  /// In en, this message translates to:
  /// **'e.g., Speech Therapist'**
  String get hintSpecialization;

  /// No description provided for @licenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumber;

  /// No description provided for @hintLicense.
  ///
  /// In en, this message translates to:
  /// **'Enter your license number'**
  String get hintLicense;

  /// No description provided for @volunteerType.
  ///
  /// In en, this message translates to:
  /// **'Type of Volunteer Work'**
  String get volunteerType;

  /// No description provided for @hintVolunteerType.
  ///
  /// In en, this message translates to:
  /// **'e.g., Event helper, workshop leader'**
  String get hintVolunteerType;

  /// No description provided for @thisFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldRequired;

  /// Greeting with user name
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(String name);

  /// No description provided for @workshopOverview.
  ///
  /// In en, this message translates to:
  /// **'Here is your workshop overview'**
  String get workshopOverview;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approvedTab.
  ///
  /// In en, this message translates to:
  /// **'Approved ✅'**
  String get approvedTab;

  /// No description provided for @pendingTab.
  ///
  /// In en, this message translates to:
  /// **'Pending ⏳'**
  String get pendingTab;

  /// No description provided for @noItemsHere.
  ///
  /// In en, this message translates to:
  /// **'No items here'**
  String get noItemsHere;

  /// No description provided for @addNewWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Add New Workshop'**
  String get addNewWorkshop;

  /// No description provided for @newWorkshopDetails.
  ///
  /// In en, this message translates to:
  /// **'New Workshop Details 🌟'**
  String get newWorkshopDetails;

  /// No description provided for @workshopTitle.
  ///
  /// In en, this message translates to:
  /// **'Workshop Title'**
  String get workshopTitle;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @ageGroup.
  ///
  /// In en, this message translates to:
  /// **'Age Group (e.g. 5-8 yrs)'**
  String get ageGroup;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @allAges.
  ///
  /// In en, this message translates to:
  /// **'All Ages'**
  String get allAges;

  /// No description provided for @workshopSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Workshop submitted for approval!'**
  String get workshopSubmitted;

  /// No description provided for @childProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Child Profile'**
  String get childProfileTitle;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'PERSONAL INFORMATION'**
  String get personalInformation;

  /// No description provided for @childFullName.
  ///
  /// In en, this message translates to:
  /// **'Child\'s Full Name'**
  String get childFullName;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @medicalProfile.
  ///
  /// In en, this message translates to:
  /// **'MEDICAL PROFILE'**
  String get medicalProfile;

  /// No description provided for @autismLevel.
  ///
  /// In en, this message translates to:
  /// **'Autism Level'**
  String get autismLevel;

  /// No description provided for @level1Mild.
  ///
  /// In en, this message translates to:
  /// **'Level 1 - Mild'**
  String get level1Mild;

  /// No description provided for @level2Moderate.
  ///
  /// In en, this message translates to:
  /// **'Level 2 - Moderate'**
  String get level2Moderate;

  /// No description provided for @level3Severe.
  ///
  /// In en, this message translates to:
  /// **'Level 3 - Severe'**
  String get level3Severe;

  /// No description provided for @behavioralDescription.
  ///
  /// In en, this message translates to:
  /// **'Behavioral Description'**
  String get behavioralDescription;

  /// No description provided for @behavioralHint.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe social skills, sensory needs, etc.'**
  String get behavioralHint;

  /// No description provided for @severeCondition.
  ///
  /// In en, this message translates to:
  /// **'Severe Medical Condition?'**
  String get severeCondition;

  /// No description provided for @specifyCondition.
  ///
  /// In en, this message translates to:
  /// **'Specify condition (diabetes, severe allergies...)'**
  String get specifyCondition;

  /// No description provided for @saveChildProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Child Profile'**
  String get saveChildProfile;

  /// No description provided for @childProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Child profile saved!'**
  String get childProfileSaved;

  /// No description provided for @dailyProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get dailyProgressTitle;

  /// No description provided for @howWasDay.
  ///
  /// In en, this message translates to:
  /// **'How was your child\'s day?'**
  String get howWasDay;

  /// No description provided for @currentMood.
  ///
  /// In en, this message translates to:
  /// **'Current Mood'**
  String get currentMood;

  /// No description provided for @dailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get dailyGoals;

  /// No description provided for @sensoryPlay.
  ///
  /// In en, this message translates to:
  /// **'Completed Sensory Play'**
  String get sensoryPlay;

  /// No description provided for @socialInteraction.
  ///
  /// In en, this message translates to:
  /// **'Social Interaction (Playdate/Park)'**
  String get socialInteraction;

  /// No description provided for @parentNotes.
  ///
  /// In en, this message translates to:
  /// **'Parent Notes'**
  String get parentNotes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter any specific triggers or achievements...'**
  String get notesHint;

  /// No description provided for @saveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save Entry'**
  String get saveEntry;

  /// No description provided for @progressSaved.
  ///
  /// In en, this message translates to:
  /// **'Progress Saved!'**
  String get progressSaved;

  /// No description provided for @resourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Resources'**
  String get resourcesTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search topics...'**
  String get searchHint;

  /// No description provided for @readFullArticle.
  ///
  /// In en, this message translates to:
  /// **'Read Full Article'**
  String get readFullArticle;

  /// No description provided for @eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Events'**
  String get eventsTitle;

  /// No description provided for @imInterested.
  ///
  /// In en, this message translates to:
  /// **'I\'m Interested'**
  String get imInterested;

  /// No description provided for @interestNoted.
  ///
  /// In en, this message translates to:
  /// **'Interest noted! More details soon.'**
  String get interestNoted;

  /// No description provided for @specialistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Specialists'**
  String get specialistsTitle;

  /// No description provided for @viewComments.
  ///
  /// In en, this message translates to:
  /// **'View comments from other parents'**
  String get viewComments;

  /// No description provided for @contactButton.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactButton;

  /// No description provided for @contactFeatureComing.
  ///
  /// In en, this message translates to:
  /// **'Contact {name} feature coming soon'**
  String contactFeatureComing(Object name);

  /// No description provided for @bookAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointmentTitle;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categorySpeechTherapist.
  ///
  /// In en, this message translates to:
  /// **'Speech Therapist'**
  String get categorySpeechTherapist;

  /// No description provided for @categoryPsychologist.
  ///
  /// In en, this message translates to:
  /// **'Psychologist'**
  String get categoryPsychologist;

  /// No description provided for @categoryBehavioralSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Behavioral Specialist'**
  String get categoryBehavioralSpecialist;

  /// No description provided for @noSpecialistsFound.
  ///
  /// In en, this message translates to:
  /// **'No specialists found'**
  String get noSpecialistsFound;

  /// No description provided for @bookButton.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get bookButton;

  /// No description provided for @bookingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Booking feature coming soon'**
  String get bookingComingSoon;

  /// No description provided for @helloParent.
  ///
  /// In en, this message translates to:
  /// **'Hello, Parent! 👋'**
  String get helloParent;

  /// No description provided for @dailySummary.
  ///
  /// In en, this message translates to:
  /// **'Here is your daily summary.'**
  String get dailySummary;

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get upNext;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @childProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to complete or update info'**
  String get childProfileSubtitle;

  /// No description provided for @menuBookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get menuBookAppointment;

  /// No description provided for @menuSpecialists.
  ///
  /// In en, this message translates to:
  /// **'Specialists'**
  String get menuSpecialists;

  /// No description provided for @menuDailyProgress.
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get menuDailyProgress;

  /// No description provided for @menuResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get menuResources;

  /// No description provided for @menuCommunityEvents.
  ///
  /// In en, this message translates to:
  /// **'Community Events'**
  String get menuCommunityEvents;

  /// No description provided for @upcomingTherapy.
  ///
  /// In en, this message translates to:
  /// **'Speech Therapy'**
  String get upcomingTherapy;

  /// No description provided for @upcomingDoctor.
  ///
  /// In en, this message translates to:
  /// **'Dr. Sarah Wilson'**
  String get upcomingDoctor;

  /// No description provided for @timeHour.
  ///
  /// In en, this message translates to:
  /// **'4:00'**
  String get timeHour;

  /// No description provided for @timePeriod.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get timePeriod;

  /// No description provided for @clientDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Client Details'**
  String get clientDetailsTitle;

  /// No description provided for @ageYearsOld.
  ///
  /// In en, this message translates to:
  /// **'Age: {age} years old'**
  String ageYearsOld(String age);

  /// No description provided for @diagnosisTreatment.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis & Treatment'**
  String get diagnosisTreatment;

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// No description provided for @therapyType.
  ///
  /// In en, this message translates to:
  /// **'Therapy Type'**
  String get therapyType;

  /// No description provided for @sessionFrequency.
  ///
  /// In en, this message translates to:
  /// **'Session Frequency'**
  String get sessionFrequency;

  /// No description provided for @parentInfo.
  ///
  /// In en, this message translates to:
  /// **'Parent Info'**
  String get parentInfo;

  /// No description provided for @parentNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get parentNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @contactParent.
  ///
  /// In en, this message translates to:
  /// **'Contact Parent'**
  String get contactParent;

  /// No description provided for @currentTreatmentGoals.
  ///
  /// In en, this message translates to:
  /// **'Current Treatment Goals'**
  String get currentTreatmentGoals;

  /// No description provided for @recentProgress.
  ///
  /// In en, this message translates to:
  /// **'Recent Progress'**
  String get recentProgress;

  /// No description provided for @importantNotes.
  ///
  /// In en, this message translates to:
  /// **'Important Notes'**
  String get importantNotes;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @communityEventsSpecialistTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Events for Specialists'**
  String get communityEventsSpecialistTitle;

  /// No description provided for @seatReserved.
  ///
  /// In en, this message translates to:
  /// **'Seat reserved! 📅'**
  String get seatReserved;

  /// No description provided for @reservationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Reservation cancelled.'**
  String get reservationCancelled;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'Registered ✓'**
  String get registered;

  /// No description provided for @reserveSpot.
  ///
  /// In en, this message translates to:
  /// **'Reserve Spot'**
  String get reserveSpot;

  /// No description provided for @categoryTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get categoryTraining;

  /// No description provided for @categoryPeerReview.
  ///
  /// In en, this message translates to:
  /// **'Peer Review'**
  String get categoryPeerReview;

  /// No description provided for @categoryConference.
  ///
  /// In en, this message translates to:
  /// **'Conference'**
  String get categoryConference;

  /// No description provided for @myClientsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Clients'**
  String get myClientsTitle;

  /// No description provided for @lastSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Session:'**
  String get lastSessionLabel;

  /// No description provided for @nextPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Next Plan:'**
  String get nextPlanLabel;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @parentPrefix.
  ///
  /// In en, this message translates to:
  /// **'Parent: {parentName}'**
  String parentPrefix(String parentName);

  /// No description provided for @pendingRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequestsTitle;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All Caught Up!'**
  String get allCaughtUp;

  /// No description provided for @noPendingAppointments.
  ///
  /// In en, this message translates to:
  /// **'You have no pending appointments requests.'**
  String get noPendingAppointments;

  /// No description provided for @acceptedRequest.
  ///
  /// In en, this message translates to:
  /// **'Accepted request from {name}'**
  String acceptedRequest(String name);

  /// No description provided for @declinedRequest.
  ///
  /// In en, this message translates to:
  /// **'Declined request from {name}'**
  String declinedRequest(String name);

  /// No description provided for @welcomeSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Dr. {name}!'**
  String welcomeSpecialist(String name);

  /// No description provided for @appointmentsCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} appointments today.'**
  String appointmentsCount(String count);

  /// No description provided for @upNextSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get upNextSpecialist;

  /// No description provided for @startsInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Starts in {minutes} mins'**
  String startsInMinutes(String minutes);

  /// No description provided for @practiceOverview.
  ///
  /// In en, this message translates to:
  /// **'Practice Overview'**
  String get practiceOverview;

  /// No description provided for @pendingRequestsButton.
  ///
  /// In en, this message translates to:
  /// **'Pending\nRequests'**
  String get pendingRequestsButton;

  /// No description provided for @todayAppointmentsButton.
  ///
  /// In en, this message translates to:
  /// **'Today\'s\nAppointments'**
  String get todayAppointmentsButton;

  /// No description provided for @myClientsButton.
  ///
  /// In en, this message translates to:
  /// **'My\nClients'**
  String get myClientsButton;

  /// No description provided for @communityEventsButton.
  ///
  /// In en, this message translates to:
  /// **'Community\nEvents'**
  String get communityEventsButton;

  /// No description provided for @badgeNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get badgeNew;

  /// No description provided for @badgeCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get badgeCheck;

  /// No description provided for @badgeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get badgeViewAll;

  /// No description provided for @badgeJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get badgeJoin;

  /// No description provided for @upcomingAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointmentsTitle;

  /// No description provided for @tagTherapy.
  ///
  /// In en, this message translates to:
  /// **'Therapy'**
  String get tagTherapy;

  /// No description provided for @tagCheckup.
  ///
  /// In en, this message translates to:
  /// **'Check-up'**
  String get tagCheckup;

  /// No description provided for @tagConsultation.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get tagConsultation;

  /// No description provided for @tagFollowup.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get tagFollowup;
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
