import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController todo = TextEditingController();

  Box todoBox = Hive.box('todo');
  List todos = [];
  initHives() async {
    await Hive.openBox('todo');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initHives();
  }

  List getListData() {
    Hive.initFlutter();
    Hive.openBox("todo");
    return todoBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    todos = getListData();

    return Scaffold(
      backgroundColor: Color.fromRGBO(230, 230, 230, 1.0),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "TO DO App",
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        focusNode: focusNode,
                        controller: todo,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type Somethig Here...."),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: FloatingActionButton(
                    elevation: 7,
                    backgroundColor: Colors.black,
                    onPressed: () {
                      setState(() {
                        todoBox.add({"name": todo.text});
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                  return todoTile(index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget todoTile(int index) {
    bool isEdit = false;
    FocusNode focusNode = FocusNode();
    Box todoBox = Hive.box('todo');

    TextEditingController todoEdit =
        TextEditingController(text: todoBox.values.toList()[index]['name']);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 50,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.check_circle_outline),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: SizedBox(
                        height: 50,
                        width: 150,
                        child: TextField(
                          readOnly: isEdit,
                          focusNode: focusNode,
                          controller: todoEdit,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        )),
                  )
                ],
              ),
              IconButton(
                onPressed: () {
                  focusNode.requestFocus();
                  isEdit = !isEdit;
                },
                icon: Icon(
                  Icons.mode_edit,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    todoBox.deleteAt(index);
                  });
                },
                icon: Icon(
                  Icons.delete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
