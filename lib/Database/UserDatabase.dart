import 'package:freehit/Entities/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Userdatabase {
  static final Userdatabase instance=Userdatabase._init();
  static Database? _database;
  Userdatabase._init();
  Future<Database> get database async{
    if(_database!=null) return _database!;
    final path=join(await getDatabasesPath(),'user.db');
    _database=await openDatabase(path,version: 1,onCreate: _createDB);
    return _database!;
  }
  Future _createDB(Database db,int version)async{
    await db.execute(
      '''
      CREATE TABLE user(
        email TEXT PRIMARY KEY,
        username TEXT,
        fullName TEXt
      )
      '''
    );
  }
  Future<int> insertUser(User user)async{
    final db=await instance.database;
    return db.insert('user', user.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<List<User>> getUsers()async{
    final db=await instance.database;
    final result=await db.query('user');
    return result.map((e)=> User.fromMap(e)).toList();
  }
}