// State class for AddContactController
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kontacts/src/features/contacts/data/contact_repository.dart';
import 'package:kontacts/src/features/contacts/domain/contact.dart';
import 'package:go_router/go_router.dart';

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

    await contactRepository
        .saveContact(Contact(name: name, phoneNumber: phone))
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Contact added successfully!')),
            ));
    Future.delayed(const Duration(milliseconds: 1500))
        .then((value) => context.pop());
    state = true; // Set state to indicate successful saving
  }

  //Update
  Future<void> updateContact(
      Contact updatedContact, int contactID, BuildContext context) async {
    await contactRepository
        .updateContact(contactID, updatedContact)
        .then((_) => context.pop());
       
  }

  //Delete
  Future<void> deleteContact(int contactID) async {
    await contactRepository.deleteContact(contactID);
  }
}

final contactStateProvider = StateNotifierProvider<AddContactController, bool>(
  (ref) => AddContactController(ref.read(contactProvider)),
);
