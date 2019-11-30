import 'package:epass/logic/account.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';

class Storage {
  static final Storage _instance = Storage._();
  Future<Database> _dbFuture;
  FlutterSecureStorage _secureStorage;
  Future<List<Account>> _accounts;

  factory Storage() => _instance;

  Storage._() {
    _setDB();
    _secureStorage = FlutterSecureStorage();
  }

  // TODO: add a stream that the data is pulled from

  Future<List<Account>> get accounts => _accounts;

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
          "UNIQUE(site, login))");
    });
  }

  Future<List<Account>> getAllAccounts() async {
    refresh();
    return _accounts;
  }

  Future<void> addAccount(Account account, String password) async {
    int id = await _dbFuture.then((db) => db.insert("Accounts", account.asMap(),
        conflictAlgorithm: ConflictAlgorithm.abort));
    print(id);
    // securely store password
    await _secureStorage.write(key: 'pw$id', value: password);
    refresh();
  }

  Future<void> updateAccountWithId(id,
      {site, login, password, authTypes}) async {
    Map<String, dynamic> map = {
      if (site != null) 'site': site,
      if (login != null) 'login': login,
    };
    await _dbFuture.then((db) => db.update("Accounts", map,
        where: "id = $id", conflictAlgorithm: ConflictAlgorithm.abort));

    if (password != null) {
      _secureStorage.write(key: 'pw$id', value: password);
    }
    refresh();
  }

  Future<void> updateAccountWithSiteAndLogin(site, login,
      {newSite, newLogin, password}) async {
    int id = (await _dbFuture.then((db) => db.query("Accounts",
            columns: ["id"],
            where: "site = '$site' AND login = '$login'",
            limit: 1)))
        .first
        .values
        .first;

    await updateAccountWithId(id,
        site: newSite, login: newLogin, password: password);
    refresh();
  }

  Future<void> removeAccount(int id) async {
    await _dbFuture.then((db) => db.transaction((txn) async {
          await txn.delete("Accounts", where: "id = $id");
        }));
    await _secureStorage.delete(key: 'pw$id');
    refresh();
  }

  Future<void> removeAll() async {
    await _dbFuture.then((db) => db.transaction((txn) async {
          await txn.delete("Accounts");
        }));
    await _secureStorage.deleteAll();
    refresh();
  }

  void refresh() async {
    _accounts = _dbFuture
        .then((db) => db.rawQuery("SELECT * FROM Accounts ORDER BY id"))
        .then((results) => results.map((r) => Account.fromMap(r)).toList());
  }

  Future close() async {
    await _dbFuture.then((db) => db.close());
  }
}
