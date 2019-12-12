class ErrorException {
  static String showError(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return "Bu Email Zaten Kullanılıyor \nLütfen Başka Bir Email Deneyiniz!";
        break;
      case "ERROR_USER_NOT_FOUND":
        return "Kullanıcı Sistemde Bulunmamaktadır.\n Lütfen Email Ve Şifrenizi Kontrol Edin!";
        break;
     case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
     return "Bu Email İle Daha Önce Gmail Veya Email İle Kayıt Olunmuştur.\n Lütfen Mail Adresi İle Giriş Yapınız";
     break;
      default:
        return "Bir Hata Oluştu.";
    }
  }
}
