import 'package:fam_care/view/home_page/home_page.dart';
import 'package:fam_care/view/input_information_page.dart';
import 'package:fam_care/view/landing_page/langding_page.dart';
import 'package:fam_care/view/login_page/login_page.dart';
import 'package:fam_care/view/register_page.dart';
import 'package:fam_care/view/test.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String landingPage = '/';
  static const String loginPage = '/loginPage';
  static const String registerpage = '/register';
  static const String loginEmailPasswordPage = '/login-email-page';
  static const String inputInformationPage = '/input-information';
  static const String homePage = '/homePage';
  static const String test = '/test';

  static final GoRouter router = GoRouter(
    initialLocation: landingPage,
    routes: [
      GoRoute(
        path: landingPage,
        builder: (context, state) => LandingPage(),
      ),
      GoRoute(
        path: loginPage,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: registerpage,
        builder: (context, state) => RegisterPage(),
      ),
      // GoRoute(
      //   path: loginEmailPasswordPage,
      //   builder: (context, state) => LoginEmailPassword(),
      // ),
      GoRoute(
        path: inputInformationPage,
        builder: (context, state) => InputInformationPage(),
      ),
      GoRoute(
        path: homePage,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: test,
        builder: (context, state) => BirthDateForm(),
      ),
    ],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      print('state.url ===> ${state.uri}');
      return null;
    },
  );
}
