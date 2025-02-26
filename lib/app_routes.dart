import 'package:fam_care/view/home_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String landingPage = '/';
  static const String loginpage = '/loginpage';

  static final GoRouter router = GoRouter(
    initialLocation: landingPage,
    routes: [
      GoRoute(
        path: landingPage,
        builder: (context, state) => const HomePage(),
      ),
      // GoRoute(
      //   path: loginpage,
      //   builder: (context, state) => LoginPage(),
      // )
    ],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      print('state.url ===> ${state.uri}');
      return null;
    },
  );
}
