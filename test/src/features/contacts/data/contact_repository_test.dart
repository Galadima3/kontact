import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:kontacts/src/features/contacts/data/contact_repository.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Given-when-then
  test(
      "Given a contact repository when instantiated then value of isar instance be return ",
      () {
    //Arrange
    final ContactRepository cr = ContactRepository();
    //Act
    final value = cr.db;
    //Assert
    expect(value, isInstanceOf<Future<Isar>>());
  });

  // test('Given a contact repository when contact is saved then value of contact is expected ', (){
  //   //Arrange
  //    final ContactRepository cr1 = ContactRepository();
  //   //Act
  //   var x = cr1.saveContact(Contact(name: "James", phoneNumber: "1234"));
  //   final value =  x;
  //   //Assert
  //   expect(value, matcher)
  // });

  // testWidgets('contact repository ...', (tester) async {
  //
  // });
}
