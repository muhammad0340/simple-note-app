import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final String docId;
  final dynamic data;
  const EditScreen({Key? key, required this.docId, required this.data})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.docId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Edit Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 15,
                  ),
                  hintText: widget.data['title'],
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          TextField(
            controller: descriController,
            decoration: InputDecoration(
              hintText: widget.data['description'],
              contentPadding: EdgeInsets.only(
                left: 15,
              ),
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('notes')
                    .doc(widget.docId)
                    .update({
                  'title': titleController.text,
                  'description': descriController.text,
                });
                // Navigator.pop(context);
                Navigator.of(context).pop();
              } catch (e) {
                print(e.toString());
              }
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
