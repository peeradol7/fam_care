import 'package:fam_care/view/home_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String landingPage = '/';

  static final GoRouter router = GoRouter(
    initialLocation: landingPage,
    routes: [
      GoRoute(
        path: landingPage,
        builder: (context, state) => const HomePage(),
      ),
    ],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      print('state.url ===> ${state.uri}');
      return null;
    },
  );
}
