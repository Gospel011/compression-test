import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FullImagePreview extends StatefulWidget {
  const FullImagePreview({super.key, required this.image});
  final XFile image;

  @override
  State<FullImagePreview> createState() => _FullImagePreviewState();
}

class _FullImagePreviewState extends State<FullImagePreview> {
  late TransformationController transformationController;
  @override
  void initState() {
    super.initState();
    transformationController = TransformationController();
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        transformationController: transformationController,
        child: GestureDetector(
          onDoubleTap: () {
              transformationController.value = Matrix4.identity();
            // setState(() {
            // });
          },
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Image.file(File(widget.image.path), fit: BoxFit.cover),
                ),

                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    // padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
