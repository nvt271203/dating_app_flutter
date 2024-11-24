import 'dart:io';

import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});

  final void Function(File pickedImage) onPickedImage;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickCamera() async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null){
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onPickedImage(_pickedImageFile!);
  }

  void _pickImage() async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null){
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : AssetImage('assets/images/avatar_default.jpg'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical:20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ToolsColors.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: TextButton.icon(onPressed: _pickCamera,
                  label: Text("Camera ", style: TextStyle(
                      color: Theme.of(context).colorScheme.primary
                  ),),
                  icon: const Icon(Icons.camera_alt),),
              ),
              SizedBox(width: 20,),
              Container(
                decoration: BoxDecoration(
                    color: ToolsColors.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: TextButton.icon(onPressed: _pickImage,
                  label: Text("Picture ", style: TextStyle(
                      color: Theme.of(context).colorScheme.primary
                  ),),
                  icon: const Icon(Icons.image),),
              )

            ],
          ),
        )


      ],
    );
  }
}
