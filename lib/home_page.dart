import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_notes_app/edit_screen.dart';
import 'package:simple_notes_app/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Home Page"),
      ),
      body:
          // StreamBuilder(
          //   stream: FirebaseFirestore.instance
          //       .collection("users")
          //       .doc(FirebaseAuth.instance.currentUser!.uid)
          //       .snapshots(),
          //   builder: (context, snapshot) {
          //     if (!snapshot.hasData) {
          //       return Center(
          //         child: Text("no data is found "),
          //       );
          //     }
          //     return Text(snapshot.data?.data()!['username']);
          //   },
          // ),
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // InkWell(
          //   onTap: (){
          //     Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfileScreen()));
          //   },
          //   child: Container(
          //     height: 60,
          //     width:60,
          //     color: Colors.teal,
          //   ),
          // ),

          Container(
            height: MediaQuery.of(context).size.height - 80,
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("notes").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 12.0,
                                left: 12,
                                top: 10,
                              ),
                              child: Text(
                                snapshot.data!.docs[index]['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 12.0, left: 12, top: 5),
                              child: Text(
                                snapshot.data!.docs[index]['description'],
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (_) {
                                      return EditScreen(
                                        docId: snapshot.data!.docs[index].id,
                                        data: snapshot.data!.docs[index],
                                      );
                                    }));
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                // IconButton(
                                //   onPressed: () {},
                                //   icon: Icon(Icons.add_circle),
                                // ),
                                SizedBox(
                                  width: 250,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            child: AlertDialog(
                                              title: Text(""),
                                              content:
                                                  Text("Do you want to delete"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    try {
                                                      FirebaseFirestore.instance
                                                          .collection('notes')
                                                          .doc(snapshot.data!
                                                              .docs[index].id)
                                                          .delete();
                                                      Navigator.of(context)
                                                          .pop();
                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                  },
                                                  child: Text("YES"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("NO"),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Text("no data found ");
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("this is floating action button");
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: EdgeInsets.only(
                          left: 15,
                        ),
                      ),
                    ),
                    TextField(
                      controller: descriController,
                      decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          contentPadding: EdgeInsets.only(left: 15)),
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('notes')
                              .add({
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                            'title': titleController.text,
                            'description': descriController.text,
                          });
                          Navigator.pop(context);
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            "save",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
