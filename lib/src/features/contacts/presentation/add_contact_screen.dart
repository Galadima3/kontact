

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kontacts/src/features/contacts/presentation/contact_controller.dart';

class AddContactScreen extends ConsumerStatefulWidget {
  const AddContactScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddContactScreenState();
}

class _AddContactScreenState extends ConsumerState<AddContactScreen> {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isVerified = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  // void addContact(
  //     WidgetRef ref, String name, String phone, BuildContext context) {
  //   int? parsedPhone = int.tryParse(phone);
  //   if (parsedPhone != null) {
  //     ref
  //         .read(contactProvider)
  //         .saveContact(Contact(name: name, phoneNumber: parsedPhone));

  //     // Show a snackbar indicating successful saving
  //     final scaffoldMessenger = ScaffoldMessenger.of(context);
  //     scaffoldMessenger.showSnackBar(
  //       const SnackBar(
  //         content: Text('Contact saved successfully!'),
  //       ),
  //     );
  //   } else {
  //     // Handle invalid phone number input
  //     final scaffoldMessenger = ScaffoldMessenger.of(context);
  //     scaffoldMessenger.showSnackBar(
  //       const SnackBar(
  //         content: Text('Invalid phone number format!'),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final contactController = ref.read(contactStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        centerTitle: true,
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //name
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: height * 0.05),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            //phoneNumber
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Phone',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            ElevatedButton(
                onPressed: nameController.text.isNotEmpty &&
                        phoneNumberController.text.isNotEmpty
                    ? () => contactController.addContact(
                          nameController.text,
                          phoneNumberController.text,
                          context
                        )
                    : null,
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
