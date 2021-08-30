import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController todo = TextEditingController();

  @override
  void initState() {
    super.initState();
    initFire();
  }

  initFire() async {
    await Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference firebaseInstance =
        FirebaseFirestore.instance.collection("todo");
    FocusNode focusNode = FocusNode();
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
                        firebaseInstance.add({
                          "todo": todo.text,
                        });
                        focusNode.unfocus();
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
              child: FutureBuilder(
                future: getData(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  QuerySnapshot<Map<String, dynamic>>? data =
                      asyncSnapshot.data;
                  return ListView.builder(
                    itemCount: data!.size,
                    itemBuilder: (context, index) =>
                        todoTile(asyncSnapshot.data!.docs[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget todoTile(
    QueryDocumentSnapshot? snapshort,
  ) {
    bool isEdit = false;
    FocusNode focusNode = FocusNode();
    TextEditingController todoEdit =
        TextEditingController(text: snapshort!.get("todo"));
    CollectionReference firebaseInstance =
        FirebaseFirestore.instance.collection("todo");
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
                          onChanged: (value) {
                            firebaseInstance.doc(snapshort.id).update(
                              {"todo": todoEdit.text},
                            );
                          },
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
                    snapshort.reference.delete();
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

  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    await Firebase.initializeApp();
    return FirebaseFirestore.instance.collection("todo").get();
  }
}
