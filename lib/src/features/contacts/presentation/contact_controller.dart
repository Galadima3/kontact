// State class for AddContactController
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kontacts/src/features/contacts/data/contact_repository.dart';
import 'package:kontacts/src/features/contacts/domain/contact.dart';

class AddContactController extends StateNotifier<bool> {
  AddContactController(this.contactRepository) : super(false);
  final ContactRepository contactRepository;

  // Function to add contact with validation
  Future<void> addContact(
      String name, String phone, BuildContext context) async {
    if (name.isEmpty) {
      state = false; // Set state to indicate invalid name
      return;
    }

    int? parsedPhone = int.tryParse(phone);
    if (parsedPhone == null) {
      state = false; // Set state to indicate invalid phone number
      return;
    }

    await contactRepository
        .saveContact(Contact(name: name, phoneNumber: parsedPhone))
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Contact added successfully!')),
            ))
        .whenComplete(() => Future.delayed(const Duration(milliseconds: 1500)))
        .then((value) => Navigator.of(context).pop());
    state = true; // Set state to indicate successful saving
  }

  //Update

  //Delete
}

final contactStateProvider = StateNotifierProvider<AddContactController, bool>(
  (ref) => AddContactController(ref.read(contactProvider)),
);
