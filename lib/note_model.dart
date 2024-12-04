import 'package:todo_app/db_helper.dart';

class NoteModel {
  int? id;
  String title;
  String desc;
  int complted;
  String createdAt;
  String completedDate;

  NoteModel(
      {this.id,
      required this.title,
      required this.desc,
      required this.complted,
        required this.createdAt,
         required this.completedDate});

  factory NoteModel.fromMap(Map<String,dynamic> map){
  return NoteModel(
    id: map[DbHelper.TABLE_ID],
      title: map[DbHelper.TABLE_COLUMN_TITLE],
      desc: map[DbHelper.TABLE_COLUMN_DESC],
      complted: map[DbHelper.TABLE_COLUMN_COMPLETED],
      createdAt: map[DbHelper.TABLE_COLUMN_CREATED_AT],
      completedDate: map[DbHelper.TABLE_COLUMN_COMPLETEDATE]);
  }


  Map<String,dynamic> toMap(){
    return {
      DbHelper.TABLE_COLUMN_TITLE:title,
      DbHelper.TABLE_COLUMN_DESC:desc,
      DbHelper.TABLE_COLUMN_COMPLETED:complted,
      DbHelper.TABLE_COLUMN_CREATED_AT:createdAt,
      DbHelper.TABLE_COLUMN_COMPLETEDATE:completedDate,
    };
  }
}
