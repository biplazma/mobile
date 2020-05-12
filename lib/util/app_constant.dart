class AppConstant {
  static const String appName = 'BiPlazma';
  static const String appDescription = 'BiPlazma developed for Google Solution Marathon Contest';
  static const String appVersion = "v0.1";
  static final String svgGoogleLogo = "assets/svg/google_logo.svg";
  static final String svgMale = "assets/svg/male.svg";
  static final String svgFemale = "assets/svg/female.svg";
  static String userToken = '';
  static bool isRegistered = false;
  static bool isPlasmaRequested = false;
  static bool donateAgreement = false;

  static final String regexRegister =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // Onboarding Page
  static final String onboardingTitle1 = "Plazma Bağışla";
  static final String onboardingTitle2 = "Sosyal Mesafeni Koru";
  static final String onboardingTitle3 = "Yardım Et!";
  static final String onboardingTitle4 = "Aman Belirtilere Dikkat!";

  static final String onboardingBody1 = "Hayat ver! 1 saat bile sürmüyor.";
  static final String onboardingBody2 = "Hastalığı yenmiş olsan bile, tekrar kapmayacağın anlamına gelmez. En az 2 metre uzak dur!";
  static final String onboardingBody3 = "Bu uygulama ile sana en yakın dönor ya da hastaları tek tıkla bulabilirsin.";
  static final String onboardingBody4 = "Halsizlik, ateş, öksürük vb belirtiler varsa sakın evden çıkma ve hemen yetkilileri ara!";

  static final String onboardingAnimation1 = "assets/json/anim/kanbagisi.json";
  static final String onboardingAnimation2 = "assets/json/anim/uzakdur.json";
  static final String onboardingAnimation3 = "assets/json/anim/tektik.json";
  static final String onboardingAnimation4 = "assets/json/anim/belirti.json";

  static final String skip = "Atla";
  static final String done = "Bitir";
  // #Onboarding Page

  // Login Page
  static final String welcome = "Hoşgeldin";
  static final String loginEmailButton = "Email ile devam et";
  static final String loginGoogleButton = "Google ile giriş yap";
  static final String loginRegister = "Giriş Yap / Kayıt Ol";
  static final String forgetPassword = "Şifremi Unuttum";
  static final String logi = "Giriş Yap / Kayıt Ol";
  static final String back = "Geri Dön";

  static final String enterEmail = "E-mail adresinizi giriniz";
  static final String enterPassword = "Şifrenizi giriniz";
  static final String fieldRequired = "Bu alan gerekli";
  static final String errorEmail = "Bu alan gerekli";
  static final String errorPassword = "Şifreniz 8 karakterden küçük olamaz";
  static final String error = "Bir şeyler ters gitti";
  static final String noFindMail = "Geçerli bir e-mail girmelisiniz.";
  static final String wrongMail = "Hatalı email!";
  static final String sentMail = "E-mail adresinize sıfırlama maili gönderildi.";

  static final String loginSnackBarDevam = "Devam etmeniz durumunda ";
  static final String loginSnackBarGizlilik = "Gizlilik Şartları";
  static final String loginSnackBarKullanim = "Kullanım Koşulları";
  static final String loginSnackBarKabul = "\'nı kabul etmiş sayılacaksınız.";

  static final String loginSnackBarSartUrl = "https://biplazma.github.io/privacypolicy/";
  static final String loginSnackBarKosulUrl = "https://biplazma.github.io/termsandconditions/";
  // #Login Page

  // Home Page
  static final String homeSnackBar = "Çıkmak için tekrar basın.";
  static final String noData = "Veri yok !";
  static final String now = "Şuan";
  static final String donation = "Bağışçı";
  static final String requestPlasma = "Plazma Bekleyen";
  static final String donatePlasma = "Plazma Bağışla";
  static final String createRequestPlasma = "Plazma Talebi Oluştur";
  static final String alertTitle = "Uyarı!";
  static final String alertDescription = "Plazma talebiniz sistemde bulunuyor. Tekrar oluşturmanıza gerek yok.";
  static final String ok = "Tamam";
  // #Home Page

  // Settings Page
  static final String twitterURL = "https://twitter.com/Flutter_Turkiye";
  static final String githubURL = "https://github.com/biplazma";
  static final String github = "Github";
  static final String contributors = "Katkıda Bulunanlar";
  static final String logout = "Çıkış Yap";
  static final String appInfo = "Uygulama Hakkında";
  static final String settingsSnackBarDesc = "Coded with 💙 in Turkey 🇹🇷";
  // #Settings Page

}
