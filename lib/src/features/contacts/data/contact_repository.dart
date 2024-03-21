import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import '../domain/contact.dart';

class ContactRepository {
  late Future<Isar> db;

  ContactRepository() {
    db = openDB();
  }
  Future<Isar> openDB() async {
    var dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [ContactSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  //Create
  Future<void> saveContact(Contact newContact) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.contacts.putSync(newContact));
  }

  //Listen to changes in the Contact collection and yield a stream of contacts
  Stream<List<Contact>> listenContact() async* {
    final isar = await db;
    yield* isar.contacts.where().watch(fireImmediately: true);
  }

  //Read
  Future<List<Contact>> getAllContacts() async {
    final isar = await db;
    return await isar.contacts.where().findAll();
  }

  // Update an existing contact
  Future<void> updateContact(Contact updatedContact) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.contacts.put(updatedContact);
    });
  }

  //Delete a contact
  Future<void> deleteContact(int contactID) async {
    final isar = await db;
    isar.writeTxn(() => isar.contacts.delete(contactID));
  }

  //Search/Filter
  Future<Contact?> filterName() async {
    final isar = await db;
    //Use the Isar query API to filter users based on specific criteria and return the first matching result.
    final favorites =
        await isar.contacts.filter().nameContains("test").findFirst();
    return favorites;
  }
}

final contactProvider = Provider<ContactRepository>((ref) {
  return ContactRepository();
});

final contactStreamProvider = StreamProvider((ref) async* {
  final rex = ref.watch(contactProvider);
  yield* rex.listenContact();
});