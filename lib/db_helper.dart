import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/note_model.dart';

class DbHelper{

  ///Step 1 make a private Constructor
  DbHelper._();

  ////Step 2 creating a static global instance to this class
  static final instance = DbHelper._();

  // static DbHelper getInstance() =>DbHelper._(); ///you can also use this function

  ///open Db
  Database? mDb;

  static final String TABLE_TASK = "todo";
  static final String TABLE_ID = "t_id";
  static final String TABLE_COLUMN_TITLE = "t_title";
  static final String TABLE_COLUMN_DESC = "t_desc";
  static final String TABLE_COLUMN_COMPLETED = "t_completed";
  static final String TABLE_COLUMN_CREATED_AT = "t_created_at";
  static final String TABLE_COLUMN_COMPLETEDATE = "t_complete_date";


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
      db.execute("create table $TABLE_TASK ( $TABLE_ID integer primary key autoincrement, $TABLE_COLUMN_TITLE text not null, $TABLE_COLUMN_DESC text not null, $TABLE_COLUMN_COMPLETED integer not null default 0, $TABLE_COLUMN_CREATED_AT text, $TABLE_COLUMN_COMPLETEDATE text)");
    });
  }

  ///make function for add Task this function is first call initial db function when initdb is not null so db is open whenever db is created

  ///insert query
  Future<bool> addTask (NoteModel newNote)async{
    Database db = await initDb();
   int rowseffected = await db.insert(TABLE_TASK, newNote.toMap()
     /*{
     TABLE_COLUMN_TITLE : title,
     TABLE_COLUMN_DESC : desc,
     TABLE_COLUMN_COMPLETED : 0,
     TABLE_COLUMN_CREATED_AT : DateTime.now().microsecondsSinceEpoch.toString(),
     TABLE_COLUMN_COMPLETEDATE : dueDateAt,
    }*/
   );
   //return true if the insertion was successful
    print("Rows effected succsesfully");
   return rowseffected>0;
  }

  ///Select query
 /* Future<List<Map<String,dynamic>>> fetchalltask() async{
  //first call function init
  Database db  = await initDb();
  //db.query for select query function
  List<Map<String,dynamic>> allTask  = await db.query(TABLE_TASK);

    return allTask;
  }*/

  ///Select Query by NoteModel
  Future<List<NoteModel>> fetchalltask() async{
    Database db = await initDb();
    List<NoteModel> mtask = [];

    List<Map<String,dynamic>> allTask  = await db.query(TABLE_TASK);

    for(Map<String,dynamic> eachdata in allTask){
      NoteModel eachtask = NoteModel.fromMap(eachdata);
      mtask.add(eachtask);
    }

    return mtask;
  }


  ///Update task
  Future<bool> updateTask(int id,String title,String desc,bool isCompleted)async{
    Database db = await initDb();
   int rowsefected = await db.update(TABLE_TASK, {
     TABLE_COLUMN_TITLE : title,
     TABLE_COLUMN_DESC : desc,
     TABLE_COLUMN_COMPLETED : isCompleted ? 1 :0},
      where: "$TABLE_ID = ?",whereArgs: ['$id']);
   print("Rows affected by updated");
   return rowsefected>0;
  }

  Future<bool> deleatenote({required int id}) async{
    Database db = await initDb();
    int rowseffected =await db.delete(TABLE_TASK,where: "$TABLE_ID = ?" ,whereArgs: ['$id']);

    return rowseffected>0;
  }

}