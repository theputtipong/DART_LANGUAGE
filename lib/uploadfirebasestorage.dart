// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterallplatforms/service.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'save_as.dart';

enum UploadType { string, file, clear }

class UploadFirebaseStorage extends StatefulWidget {
  const UploadFirebaseStorage({super.key});

  @override
  State<UploadFirebaseStorage> createState() => _UploadFirebaseStorageState();
}

class _UploadFirebaseStorageState extends State<UploadFirebaseStorage> {
  static const String _textAppBar = 'Upload Firebase Storage Page';
  List<UploadTask> _uploadTasks = [];

  UploadTask uploadString() {
    const String putStringText = 'This upload has been generated using the putString method! Check the metadata too!';

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref().child('flutter-tests').child('/put-string-example.txt');

    // Start upload of putString
    return ref.putString(
      putStringText,
      metadata: SettableMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'example': 'putString'},
      ),
    );
  }

  Future<UploadTask?> uploadFile(XFile? file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );
      return null;
    }
    UploadTask uploadTask;
    Reference ref = FirebaseStorage.instance.ref().child('flutter-tests').child('/some-image.jpg');
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );
    if (checkPlatform() == Platform.isWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(io.File(file.path), metadata);
    }
    return Future.value(uploadTask);
  }

  Future<void> handleUploadType(UploadType type) async {
    switch (type) {
      case UploadType.string:
        setState(() {
          _uploadTasks = [..._uploadTasks, uploadString()];
        });
        break;
      case UploadType.file:
        final file = await ImagePicker().pickImage(source: ImageSource.gallery);
        UploadTask? task = await uploadFile(file);
        if (task != null) {
          setState(() => _uploadTasks = [..._uploadTasks, task]);
        }
        break;
      case UploadType.clear:
        setState(() => _uploadTasks = []);
        break;
    }
  }

  void _removeTaskAtIndex(int index) {
    setState(() {
      _uploadTasks = _uploadTasks..removeAt(index);
    });
  }

  Future<void> _downloadBytes(Reference ref) async {
    final bytes = await ref.getData();
    await saveAsBytes(bytes!, 'some-image.jpg');
  }

  Future<void> _downloadLink(Reference ref) async {
    final link = await ref.getDownloadURL();
    await Clipboard.setData(
      ClipboardData(
        text: link,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Success!\n Copied download URL to Clipboard!',
        ),
      ),
    );
  }

  Future<void> _downloadFile(Reference ref) async {
    final io.Directory systemTempDir = io.Directory.systemTemp;
    final io.File tempFile = io.File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();
    await ref.writeToFile(tempFile);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
          'at path: ${ref.fullPath} \n'
          'Wrote "${ref.fullPath}" to tmp-${ref.name}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_textAppBar),
        centerTitle: true,
        actions: [
          PopupMenuButton<UploadType>(
            onSelected: handleUploadType,
            icon: const Icon(Icons.add),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: UploadType.string,
                child: Text('Upload string'),
              ),
              const PopupMenuItem(
                value: UploadType.file,
                child: Text('Upload local file'),
              ),
              if (_uploadTasks.isNotEmpty)
                const PopupMenuItem(
                  value: UploadType.clear,
                  child: Text('Clear list'),
                )
            ],
          )
        ],
      ),
      body: buildListUpload(context),
    );
  }

  buildListUpload(BuildContext context) {
    return _uploadTasks.isEmpty
        ? const Center(child: Text("Press the '+' button to add a new file."))
        : ListView.builder(
            itemCount: _uploadTasks.length,
            itemBuilder: (context, index) => UploadTaskListTile(
              task: _uploadTasks[index],
              onDismissed: () => _removeTaskAtIndex(index),
              onDownloadLink: () async {
                return _downloadLink(_uploadTasks[index].snapshot.ref);
              },
              onDownload: () async {
                if (checkPlatform() == Platform.isWeb) {
                  return _downloadBytes(_uploadTasks[index].snapshot.ref);
                } else {
                  return _downloadFile(_uploadTasks[index].snapshot.ref);
                }
              },
            ),
          );
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile({
    Key? key,
    required this.task,
    required this.onDismissed,
    required this.onDownload,
    required this.onDownloadLink,
  }) : super(key: key);
  final UploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;
  final VoidCallback onDownloadLink;
  String _bytesTransferred(TaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalBytes}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (
        BuildContext context,
        AsyncSnapshot<TaskSnapshot> asyncSnapshot,
      ) {
        Widget subtitle = const Text('---');
        TaskSnapshot? snapshot = asyncSnapshot.data;
        TaskState? state = snapshot?.state;
        if (asyncSnapshot.hasError) {
          if (asyncSnapshot.error is FirebaseException &&
              (asyncSnapshot.error as FirebaseException).code == 'canceled') {
            subtitle = const Text('Upload canceled.');
          } else {
            print(asyncSnapshot.error);
            subtitle = const Text('Something went wrong.');
          }
        } else if (snapshot != null) {
          subtitle = Text('$state: ${_bytesTransferred(snapshot)} bytes sent');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: ($) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (state == TaskState.running)
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: task.pause,
                  ),
                if (state == TaskState.running)
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: task.cancel,
                  ),
                if (state == TaskState.paused)
                  IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: task.resume,
                  ),
                if (state == TaskState.success)
                  IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                if (state == TaskState.success)
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: onDownloadLink,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
