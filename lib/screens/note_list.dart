
import 'package:note_keeper/screens/note_detail.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;
    List<Note> notelist;
  @override
  Widget build(BuildContext context) {

    if(notelist==null) {
       notelist=[];

       updateListView();

    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          print('fab');
         navigateToDetail('Add Note',Note( '', '', 2));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
                child: Icon(Icons.keyboard_arrow_right),
                backgroundColor: Colors.yellow),
            title: Text(notelist[position].title),
            trailing: GestureDetector(
                child: Icon(Icons.delete, color: Colors.grey),
            
              onTap: (){
              deleteNote(notelist[position]);
          },
            ),
            
            onTap: () {
              navigateToDetail('Edit Note',this.notelist[position]);
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(String val,Note note) async{




    // bool tr=await  Navigator.push(context, route);
     bool tr=await  Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetail(val,note)));
     if(tr==true){
    updateListView();
  }
  }

 void deleteNote(Note note) async{

    DatabaseHelper databaseHelper=DatabaseHelper();

         await databaseHelper.DeleteNote(note.id);

           updateListView();



  }

  Future updateListView() async{

        DatabaseHelper databaseHelper=DatabaseHelper();

       List<Note>  note_list= await  databaseHelper.getNoteList();

       setState(() {
          this.notelist=note_list;
          this.count=note_list.length;
       });




  }
}
