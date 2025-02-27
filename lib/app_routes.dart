import 'package:fam_care/view/input_information_page.dart';
import 'package:fam_care/view/langding_page.dart';
//import 'package:fam_care/view/login_email_password.dart';
import 'package:fam_care/view/login_page.dart';
import 'package:fam_care/view/register_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String landingPage = '/';
  static const String loginPage = '/loginpage';
  static const String registerpage = '/register';
  static const String inputInformationPage = '/input-information';
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
      )
    ],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      print('state.url ===> ${state.uri}');
      return null;
    },
  );
}
