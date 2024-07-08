import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onSelectedImage});
  final void Function(File file) onSelectedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _takeImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 50,
    );
    if(image == null){
      return;
    }
    setState((){
      _pickedImage = File(image.path);
    });
    widget.onSelectedImage(_pickedImage!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
            onPressed: _takeImage,
            icon: const Icon(Icons.image),
            label: Text("Add Image",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary
              ),
            ),),
      ],
    );
  }
}
