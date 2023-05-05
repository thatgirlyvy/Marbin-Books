import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/book_rating.dart';
import '../model/book.dart';
import '../services/crud.dart';

class EditScreen extends StatefulWidget {
  final BookModel book;
  const EditScreen({super.key, required this.book});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  TextEditingController? titleController;
  TextEditingController? authorController;
  TextEditingController? descriptionController;

  File? _image;
  final _picker = ImagePicker();
  int? note;
  String? imageUrl;
  bool? isFavorite;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.book.title);
    authorController = TextEditingController(text: widget.book.author);
    descriptionController = TextEditingController(text: widget.book.description);
    imageUrl = widget.book.imageUrl;
    note = int.parse(widget.book.note!);
    isFavorite = widget.book.isFavorite;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController!.dispose();
    authorController!.dispose();
    descriptionController!.dispose();
  }

  Future<void> _openImagePicker() async {

    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
                    Reference referenceImageToUpload = FirebaseStorage.instance.refFromURL(widget.book.imageUrl!);

                         try {
                      //Store the file
                      await referenceImageToUpload.putFile(File(pickedImage.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      print('an error occured during update: $error');
                    }
    }
  }

    Future updateData() async {
    FirestoreHelper.update(
      BookModel(
        title: titleController!.text,
        description: descriptionController!.text,
        author: authorController!.text,
        imageUrl: imageUrl,
        note: note.toString(),
        id: widget.book.id,
        isFavorite: isFavorite
      )
    ).then((value) => Navigator.pop(context));
    print(widget.book.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
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
                    : Image.network(imageUrl!),
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
                  value: note!,);
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
              const SizedBox(height: 15),
              ElevatedButton(onPressed: () {updateData();}, child: const Text('Update'))
            ],
          ),
      ),
    ));
  }
}