enum APP_PAGE { splash, login, register, home, error, onBoarding }

extension AppPageExtension on APP_PAGE {
  String get toPath {
    switch (this) {
      case APP_PAGE.home:
        return "/";
      case APP_PAGE.error:
        return "/error";
      case APP_PAGE.login:
        return "/login";
      case APP_PAGE.register:
        return "/register";
      case APP_PAGE.onBoarding:
        return "/start";
      case APP_PAGE.splash:
        return "/splash";
      default:
        return '/';
    }
  }

  String get toName {
    switch (this) {
      case APP_PAGE.home:
        return "HOME";
      case APP_PAGE.error:
        return "ERROR";
      case APP_PAGE.login:
        return "LOGIN";
      case APP_PAGE.register:
        return "REGISTER";
      case APP_PAGE.onBoarding:
        return "START";
      case APP_PAGE.splash:
        return "SPLASH";
      default:
        return 'HOME';
    }
  }

  String get toTitle {
    switch (this) {
      case APP_PAGE.home:
        return "My App";
      case APP_PAGE.error:
        return "My App Error";
      case APP_PAGE.login:
        return "My App Login";
      case APP_PAGE.register:
        return "My App Register";
      case APP_PAGE.onBoarding:
        return "Welcome to My App";
      case APP_PAGE.splash:
        return " My App Splash";
      default:
        return 'My App';
    }
  }
}
