import 'dart:async';

import 'package:path/path.dart' as P;
import 'package:sqflite/sqflite.dart';
class SqlManager {
  // static const String tname = 'table1';
  static const String dname = 'nfcsmartcard.db';
  // Future<Database> db;

  // Make a singleton class
  SqlManager._privateConstructor();

  static final SqlManager instance = SqlManager._privateConstructor();

  // Use a single reference to the db.
  Database _db;

  // Use this getter to use the database.
  Future<Database> get database async {
    if (_db != null) return _db;
    // Instantiate db the first time it is accessed
    _db = await _initDB();
    return _db;
  }

  // Init the database for the first time.
  _initDB() async {
    return await openDatabase(P.join(await getDatabasesPath(), dname), version: 1, onCreate: (db, version)async {
      // When creating the db, create the table
      await db.execute('CREATE TABLE contacts '
          '(id INTEGER PRIMARY KEY,'
          ' name TEXT,'
          ' designation TEXT,'
          ' office_number TEXT,'
          ' mobile_number TEXT,'
          ' address TEXT,'
          ' company_name TEXT,'
          ' website TEXT'
      // ' value INTEGER,'
      // ' num REAL'
          ')');
      await db.execute('CREATE TABLE email_table '
          '(id INTEGER PRIMARY KEY,'
          ' user_id INTEGER,'
          ' email TEXT)');
      await db.execute('CREATE TABLE mobile_table '
          '(id INTEGER PRIMARY KEY,'
          ' user_id INTEGER,'
          ' mobile TEXT)');
      });
  }

  // Then you can use the database getter in another method
  Future<List<Map>> selectAllRecords() async {
    Database DB = await instance.database;
    List<Map> contactList = await DB.rawQuery('SELECT * FROM contacts');
    return contactList;
  }
}

// Insert records in a database
// await database.transaction((txn) async {
//     userId = await txn.rawInsert(
//       'INSERT INTO contacts( name, designation, office_number, mobile_number, address, company_name, website)'
//       ' VALUES('
//       ' "${nameController.text}",'
//       ' "${designationController.text}",'
//       ' "${officeNumberController.text}",'
//       ' "${mobileNumberController.text}",'
//       ' "${addressController.text}",'
//       ' "${companyNameController.text}",'
//       ' "${websiteController.text}")');
//   print('inserted Record User id : $userId}');

// for(int i=0;i<mobileNumberGroup.length-1;i++) {
//   int mobileID = await txn.rawInsert(
//       'INSERT INTO mobile_table(user_id, mobile) '
//       'VALUES('
//         ' $userId,'
//         ' ${mobileNumberGroup[i].text})');
//   print('mobile Number Inseted Id: $mobileID');
// }


// for(int i=0;i<emailAddressGroup.length-1;i++) {
//   int emailID = await txn.rawInsert(
//       'INSERT INTO email_table(user_id, email) '
//           'VALUES('
//           ' $userId,'
//           ' ${emailAddressGroup[i].text})');
//   print('email address Inseted Id: $emailID');
// }
// });

// void createDatabase()async
// {// Get a location using getDatabasesPath
//   var databasesPath = await getDatabasesPath();
//   dbPath = P.join(databasesPath, 'nfcsmartcard.db');
//   print('database path: $dbPath');
// }

// Future<void> openTheDatabase()async
// {// open the database
//   database = await openDatabase(dbPath, version: 1,
//       onCreate: (Database db, int version) async {
//         // When creating the db, create the table
//         await db.execute('CREATE TABLE contacts '
//             '(id INTEGER PRIMARY KEY,'
//             ' name TEXT,'
//             ' designation TEXT,'
//             ' office_number TEXT,'
//             ' mobile_number TEXT,'
//             ' address TEXT,'
//             ' company_name TEXT,'
//             ' website TEXT'
//             // ' value INTEGER,'
//             // ' num REAL'
//             ')');
//         await db.execute('CREATE TABLE email_table '
//             '(id INTEGER PRIMARY KEY,'
//             ' user_id INTEGER,'
//             ' email TEXT)');
//         await db.execute('CREATE TABLE mobile_table '
//             '(id INTEGER PRIMARY KEY,'
//             ' user_id INTEGER,'
//             ' mobile TEXT)');
//       });
//   }

// Future<bool> selectFirstRecord()async{
//   if(database!=null) {
//     if (database.isOpen) {
//       List <Map> contactList = await database.rawQuery('SELECT * FROM contacts LIMIT 1');
//       if(contactList.length!=0)
//         return true;
//     }
//   }
//
//   return false;
// }
