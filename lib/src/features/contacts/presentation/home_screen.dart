import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kontacts/src/features/contacts/data/contact_repository.dart';
import 'package:kontacts/src/features/contacts/domain/contact.dart';
import 'package:kontacts/src/features/contacts/presentation/add_contact_screen.dart';
import 'package:kontacts/src/features/contacts/presentation/contact_controller.dart';
import 'package:kontacts/src/features/contacts/presentation/edit_contact_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // final isar = ContactRepository();
  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactStreamProvider);
    //final dex = ref.read(contactStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kontacts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const AddContactScreen();
            },
          ));
        },
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      body: contacts.when(
        data: (data) {
          return data.isEmpty
              ? Center(
                  child: SizedBox(
                      height: 150,
                      width: 150,
                      child: SvgPicture.asset('assets/images/blank.svg')))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var lex = data[index];
                    return lex.toCard(ref, lex, context);
                  },
                );
        },
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

extension ObtainFirstChar on String {
  String firstCharacter() {
    return isEmpty ? '' : substring(0, 1);
  }
}

extension UserExtensions on Contact {
  Widget toCard(WidgetRef ref, Contact x, BuildContext context) {
    return Card(
        child: ListTile(
      //leading: Icon(Icons.person),
      title: Text(name),
      subtitle: Text(phoneNumber.toString()),
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(
          name.firstCharacter(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
     trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              // Handle edit action
              // For example, you can navigate to the edit screen
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return EditContactScreen(contact: x);
              },));
              print(id);
            } else if (value == 'delete') {
              // Handle delete action
              ref.read(contactStateProvider.notifier).deleteContact(id);
            }
          },
        ),
      
    ));
  }
}
