import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UploadFirebaseStorage extends StatefulWidget {
  const UploadFirebaseStorage({super.key});

  @override
  State<UploadFirebaseStorage> createState() => _UploadFirebaseStorageState();
}

class _UploadFirebaseStorageState extends State<UploadFirebaseStorage> {
  static const String _textAppBar = 'Upload Firebase Storage Page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_textAppBar),
        centerTitle: true,
      ),
      body: buildFormUpload(context),
    );
  }

  buildFormUpload(BuildContext context) {}
}
