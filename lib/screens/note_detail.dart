import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  String appBarTitle;
  Note note;
  NoteDetail(this.appBarTitle,this.note);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(appBarTitle,note);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper _databaseHelper;
  String _appBarTitle;
  Note _note;

  NoteDetailState(this._appBarTitle, this._note);

  static var _priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _databaseHelper = DatabaseHelper();

    titleController.text = _note.title;
    descriptionController.text = _note.description;


    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .subtitle1;


    return WillPopScope(

      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle),
          backgroundColor: Colors.blue,
          leading:IconButton(
            icon:Icon(Icons.arrow_back) ,
            onPressed: (){
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropdownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropdownStringItem,
                        child: Text(dropdownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(_note.priority),
                    onChanged: (valueselectedbyuser) {
                      setState(() {
                        debugPrint('$valueselectedbyuser');
                        updatePriorityAsInt(valueselectedbyuser);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      upDateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      upDateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              save();

                            },
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white, // foreground
                            ),
                          )),
                      Container(width: 5.0),
                      Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                               delete();
                            },
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // background
                              onPrimary: Colors.blue, // foreground
                            ),
                          ))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  void updatePriorityAsInt(String value) {
    int priority;

    switch (value) {
      case 'High':
        priority = 1;
        break;

      case 'Low':
        priority = 2;
        break;
    }
    this._note.priority=priority;
  }

  String getPriorityAsString(int value) {
    String priority;

    switch (value) {
      case 1:
        priority = _priorities[0];
        break;

      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }


  void upDateTitle() {
    this._note.title = titleController.text;
  }

  void upDateDescription() {
    this._note.description = descriptionController.text;
  }


  void save() async {


    int result;


    this._note.date= formateDate();

    if (_note.id != null) {
      result = await _databaseHelper.UpdateNote(_note); //update
    }

    else {
      result = await _databaseHelper.insertNote(_note); //insert new note

    }

    moveToLastScreen();

    if (result != 0) {
      showAlertDialogue("Status", 'Note saved successfully.');
    } else {
      showAlertDialogue("Status", 'Note not saved. ');
    }


  }

  void showAlertDialogue(String s, String t) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(s),
      content: Text(t),

    );



       showDialog(
           context: context,
           builder: (BuildContext context)=>alertDialog);


  }

  void moveToLastScreen() {

       Navigator.pop(context,true);


  }

  String formateDate() {

     DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd');
     String formatted = formatter.format(now);
      return formatted;
  }

  void delete() async{

    moveToLastScreen();

    if(_note.id==null){
      showAlertDialogue('Ststus', 'No note was deleted,');

         return;

    } else{

     int result=  await _databaseHelper.DeleteNote(_note.id);
     if (result != 0) {
       showAlertDialogue("Status", 'Note deleted  successfully.');
     } else {
       showAlertDialogue("Status", 'Error occurred . ');
     }

    }



  }
}