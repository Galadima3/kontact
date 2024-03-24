import 'package:go_router/go_router.dart';
import 'package:kontacts/src/features/contacts/domain/contact.dart';
import 'package:kontacts/src/features/contacts/presentation/screens/add_contact_screen.dart';
import 'package:kontacts/src/features/contacts/presentation/screens/edit_contact_screen.dart';
import 'package:kontacts/src/features/contacts/presentation/screens/home_screen.dart';
import 'package:kontacts/src/routing/route_paths.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          name: RoutePaths.addContactScreenRoute,
          path: RoutePaths.addContactScreenRoute,
          builder: (context, state) => const AddContactScreen(),
        ),
        GoRoute(
            name: RoutePaths.editContactScreenRoute,
            path: RoutePaths.editContactScreenRoute,
            builder: (context, state) {
              final contact = state.extra as Contact;
              return EditContactScreen(contact: contact);
            }),
      ],
    ),
  ],
);
