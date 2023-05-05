import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/book_rating.dart';
import '../model/book.dart';
import '../services/crud.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

    final titleController = TextEditingController();
  final authorController = TextEditingController();
  final descriptionController = TextEditingController();

  File? _image;
  final _picker = ImagePicker();
  int note = 0;
  String imageUrl = '';
  bool isFavorite = false;

  void clearForm() {
    titleController.clear();
    authorController.clear();
    descriptionController.clear();
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
       String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                        Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName);
                         try {
                      //Store the file
                      await referenceImageToUpload.putFile(File(pickedImage.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      //Some error occurred
                    }
    }
  }

  Future addData() async {
    FirestoreHelper.create(
      BookModel(
        title: titleController.text,
        description: descriptionController.text,
        author: authorController.text,
        imageUrl: imageUrl,
        note: note.toString(),
        isFavorite: isFavorite
      )
    ).then((value) {Navigator.pop(context); clearForm();});
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget> [
            Center(
                // this button is used to open the image picker
                child: ElevatedButton(
                  onPressed: _openImagePicker,
                  child: const Text('Select An Image'),
                ),
              ),
              const SizedBox(height: 35),
              // The picked image will be displayed here
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : const Text('Please select an image'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title'
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Author'
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description'
                ),
              ),
              const SizedBox(height: 15),
              const Text('Rate The book', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              StatefulBuilder(
                builder: (context, setState) {
                  return BookRating(onChanged: (index) {
                    setState(() {
                      note = index;
                    });
                  },
                  value: note,);
                },
              ),
              const SizedBox(height: 15),
              const Text('Mark it as favorite?'),
              Checkbox(
                value: isFavorite,
                onChanged: (value) {
                  setState(() {
                    isFavorite = value!;
                  });
                },
              ),
              const SizedBox(height: 15,),
              ElevatedButton(onPressed: () {addData();}, child: const Text('Add'))
          ],
        ),
      ),
    ));
  }
}