import 'dart:html' as html;
// for web access
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DragAndDrop extends StatefulWidget {
  const DragAndDrop({super.key});

  @override
  State<DragAndDrop> createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  Uint8List? _imageData;
  final _dropKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    dropListener();
  }

  void dropListener() {
    final dropZone =
        _dropKey.currentContext?.findRenderObject() as html.Element?;
    // this is not needed anymore due to drop event listener

    //  drag starts or while dragging over the drop zone
    html.window.addEventListener('dragover', (event) {
      event.preventDefault(); // prevent from happening anything
    });
    html.window.addEventListener('drop', (event) {
      event.preventDefault();
      event.stopPropagation(); // stops the dragging to open the file
      // event.dataTransfer.files is no longer supported in dart:html
      final files = (event as html.MouseEvent)
          .dataTransfer
          .files; // get the files from mouse event
      if (files!.isNotEmpty && files[0].type.startsWith('image/')) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _imageData = reader.result as Uint8List?;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        key: _dropKey,
        width: 500,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3),
          color: Colors.grey.withValues(alpha: 0.2),
        ),
        child: _imageData == null
            ? Center(child: Text('Drag an image here'))
            : Image.memory(_imageData!, fit: BoxFit.cover),
      ),
    );
  }
}
