import 'package:epass/logic/account.dart';
import 'package:sqflite/sqflite.dart';

class Storage {
  static final Storage _instance = Storage._();
  Future<Database> _dbFuture;

  factory Storage() => _instance;

  Storage._() {
    _setDB();
  }

  // TODO: add a stream that the data is pulled from

  Future<void> _setDB() async {
//    await deleteDatabase(await getDatabasesPath() + "accounts.db");
    _dbFuture = openDatabase('accounts.db', version: 1, onOpen: (db) async {
      //await db.execute("DROP TABLE Accounts");
//      await db.execute("CREATE TABLE IF NOT EXISTS Accounts ("
//          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
//          "site TEXT NOT NULL,"
//          "login TEXT NOT NULL,"
//          "authTypes TEXT,"
//          "UNIQUE(site, login))");
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Accounts ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "site TEXT NOT NULL,"
          "login TEXT NOT NULL,"
          "authTypes TEXT,"
          "UNIQUE(site, login))");
    });
  }

  Future<List<Account>> getAllAccounts() async {
    return _dbFuture
        .then((db) => db.rawQuery("SELECT * FROM Accounts ORDER BY id"))
        .then((results) => results.map((r) => Account.fromMap(r)).toList());
  }

  Future<void> addAccount(Account account) async {
    await _dbFuture.then((db) => db.insert("Accounts", account.asMap(),
        conflictAlgorithm: ConflictAlgorithm.abort));
  }

  Future<void> updateAccount(Account account) async {
    await _dbFuture.then((db) => db.update("Accounts", account.asMap(),
        where: "id = ${account.id}",
        conflictAlgorithm: ConflictAlgorithm.abort));
  }

  Future<void> removeAccount(int id) async {
    await _dbFuture.then((db) => db.transaction((txn) async {
          await txn.delete("Accounts", where: "id = $id");
        }));
  }

  Future<void> removeAll() async {
    await _dbFuture.then((db) => db.transaction((txn) async {
          await txn.delete("Accounts");
        }));
  }

  Future close() {
    _dbFuture.then((db) => db.close());
  }
}
