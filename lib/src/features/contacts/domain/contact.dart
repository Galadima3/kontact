import 'package:isar/isar.dart';
part 'contact.g.dart';

@collection
class Contact {
  Contact({required this.name, required this.phoneNumber});
  Id id = Isar.autoIncrement;
  final String name;
  final int phoneNumber;
}