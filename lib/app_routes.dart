import 'package:fam_care/view/home_page.dart';
import 'package:fam_care/view/login_email_password.dart';
import 'package:fam_care/view/login_page.dart';
import 'package:fam_care/view/register_page.dart';

import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String landingPage = '/';
  static const String loginpage = '/loginpage';
  static const String registerpage = '/register';
    static const String login_email_password_page = '/login_email_page';


  static final GoRouter router = GoRouter(
    initialLocation: landingPage,
    routes: [
      GoRoute(
        path: landingPage,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: loginpage,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(path: registerpage, 
              builder: (context, state) =>  RegisterPage(),
      ),
      GoRoute(path: login_email_password_page, 
              builder: (context, state) => LoginEmailPassword(),
      )
    ],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      print('state.url ===> ${state.uri}');
      return null;
    },
  );
}
