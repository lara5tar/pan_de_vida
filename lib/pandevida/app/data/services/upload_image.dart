import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  UploadImageScreenState createState() => UploadImageScreenState();
}

class UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future uploadImage() async {
    if (_image == null) return;

    var request = http.MultipartRequest('POST',
        Uri.parse('https://sistemasdevida.com/app_pan/upload_image.php'));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Imagen subida con éxito");
    } else {
      print("Error al subir imagen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subir Imagen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 150)
                : const Text("No hay imagen"),
            ElevatedButton(
                onPressed: pickImage, child: const Text("Seleccionar Imagen")),
            ElevatedButton(
                onPressed: uploadImage, child: const Text("Subir Imagen")),
          ],
        ),
      ),
    );
  }
}
