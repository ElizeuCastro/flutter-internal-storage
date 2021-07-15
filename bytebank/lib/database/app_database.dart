import 'package:bytebank/models/Contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> createDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'bytebank.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute('CREATE TABLE contacts('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'account_number NUMBER)');
    }, version: 1);
  });
}

Future<int> save(Contact contact) {
  return createDatabase().then((db) {
    final Map<String, dynamic> contacts = Map();
    contacts['name'] = contact.name;
    contacts['account_number'] = contact.accountNumber;
    return db.insert('contacts', contacts);
  });
}

Future<List<Contact>> findAll() {
  return createDatabase().then((db) {
    return db.query('contacts').then((values) {
      final List<Contact> contacts = [];
      for (Map<String, dynamic> element in values) {
        contacts.add(
          Contact(
            element['id'],
            element['name'],
            element['account_number'],
          ),
        );
      }
      return contacts;
    });
  });
}
