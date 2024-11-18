import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{

  ///Step 1 make a private Constructor
  DbHelper._();

  ////Step 2 creating a static global instance to this class
  static final instance = DbHelper._();

  // static DbHelper getInstance() =>DbHelper._(); ///you can also use this function

  ///open Db
  Database? mDb;

  ///First initial the Database when database
  Future<Database> initDb()async{
    mDb = mDb ?? await openDb();
    return mDb!;
  }

  ///now when initDb is not call and mdb is not open so we call OpenDb and create Db
  Future<Database> openDb() async{
    ///take path_provider and path by pub.dev and run in terminal
    var dairpath = await getApplicationCacheDirectory();
    ///then join the directory of path and and db name
    var dbpath = join(dairpath.path,"todo.db");
    return openDatabase(dbpath,version: 1,onCreate: (db,version){
      print("Db created");
      db.execute("create table todo ( t_id integer primary key autoincrement, t_title text not null, t_desc text not null, t_is_completed integer not null, t_duedate text, t_completedate text)");
    });
  }

  ///make function for add Task this function is first call initial db function when initdb is not null so db is open whenever db is created

  ///insert query
  Future<bool> addTask ({required String title,required String desc,required int isCompleted,required String dueDate,required String completeDate})async{
    Database db = await initDb();
   int rowseffected = await db.insert("todo", {
      "t_title" : title,
      "t_desc" : desc,
      "t_is_completed" : isCompleted,
      "t_duedate" : dueDate,
      "t_completedate" : completeDate,
    });
   //return true if the insertion was successful
   return rowseffected>0;
  }

  ///Select query
  Future<List<Map<String,dynamic>>> fetchalltask() async{
  //first call function init
  Database db  = await initDb();
  //db.query for select query function
  List<Map<String,dynamic>> allTask  = await db.query("todo");

    return allTask;
  }

}