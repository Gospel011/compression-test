import 'dart:io';

import 'package:compression_test/full_image_preview.dart';
import 'package:compression_test/mixins.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with ImageMixin {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  final Map<String, dynamic> _imageDetails = {};

  XFile? _compressedFile;
  final Map<String, dynamic> _compressedImageDetails = {};
  int compressionQuality = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("C O M P R E S S I O N   T E S T")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,

          children: [
            SizedBox(height: 16),
            GestureDetector(
              onLongPress: () {
                if (_pickedImage == null) return;

                viewImage(_pickedImage!);
              },
              onTap: () async {
                if (_pickedImage == null) {
                  pickImage();
                  return;
                } else {
                  viewImage(_pickedImage!);
                }
                // showModalBottomSheet(
                //   context: context,
                //   showDragHandle: true,
                //   builder: (context) {
                //     return Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         ListTile(
                //           title: Text("View image"),
                //           onTap: () {
                //             Navigator.pop(context);
                //             viewImage(_pickedImage!);
                //           },
                //         ),
                //         ListTile(
                //           title: Text("Select another image"),
                //           onTap: () {
                //             pickImage();
                //             Navigator.pop(context);
                //           },
                //         ),

                //         SizedBox(height: 64),
                //       ],
                //     );
                //   },
                // );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey.shade200),
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _pickedImage != null
                      ? _buildImage(_pickedImage!)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.camera,
                              size: 64,
                              color: Colors.blueGrey,
                            ),
                            Text(
                              "Select an image",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            if (_pickedImage != null)
              _buildImageDetails(
                title: "ORIGINAL IMAGE DETAILS",
                details: _imageDetails,
              ),

            if (_compressedFile != null)
              Column(
                spacing: 10,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GestureDetector(
                      onTap: () => viewImage(_compressedFile!),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: _buildImage(_compressedFile!),
                      ),
                    ),
                  ),
                  _buildImageDetails(
                    title: "COMPRESSED IMAGE DETAILS",
                    details: _compressedImageDetails,
                  ),
                ],
              ),

            SizedBox(
              height: 24,
              child: Slider(
                value: double.parse(compressionQuality.toString()),
                max: 100,

                onChanged: (value) {
                  // print("NEW RANGE VALUES: $value");

                  setState(() {
                    compressionQuality = value.round();
                  });
                },
              ),
            ),

            Text(
              "QUALITY: $compressionQuality%",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            if (_pickedImage != null)
              Wrap(
                // mainAxisSize: MainAxisSize.min,
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_pickedImage == null) return;

                      final tempDir = await getTemporaryDirectory();
                      final targetPath =
                          "${tempDir.path}/compressed-${DateTime.now().toIso8601String()}.${CompressFormat.jpeg.name}";

                      final compressedFile = compressionQuality == 100
                          ? _pickedImage
                          : await FlutterImageCompress.compressAndGetFile(
                              _pickedImage!.path,
                              targetPath,
                              quality: compressionQuality,
                              keepExif: true,
                            );

                      _compressedFile = compressedFile;
                      _compressedImageDetails['size'] = await getImageDetails(
                        _compressedFile!,
                      );
                      setState(() {});
                    },
                    child: Text("COMPRESS"),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      pickImage();
                    },
                    child: Text("Pick image"),
                  ),

                  if (_compressedFile != null)
                    ElevatedButton(
                      onPressed: () async {
                        // final dir = await getDownloadsDirectory();
                        // final mimeType = _compressedFile!.path.split('.').last;


                        // _compressedFile!.saveTo(
                        //   "$dir/${_compressedFile!.name}.$mimeType",
                        // );

                        if (context.mounted == false) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Image saved to downloads")),
                        );
                      },
                      child: Text("Save compressed image"),
                    ),
                ],
              ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildImageDetails({
    required Map<String, dynamic> details,
    required String title,
  }) {
    // return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: "Size: ",
                style: TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: formatFileSize(details['size']),
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void viewImage(XFile image) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => FullImagePreview(image: image),
        // isScrollControlled: true,
      ),
    );
  }

  Image _buildImage(XFile? image) {
    return Image.file(File(image!.path), fit: BoxFit.cover);
  }

  Future<double?> getImageDetails(XFile image) async {
    double? size = double.parse((await image.length()).toString());

    return size;
  }

  void pickImage() async {
    _pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (_pickedImage == null) return;

    _imageDetails['size'] = await getImageDetails(_pickedImage!);

    _compressedFile = null;
    _compressedImageDetails.clear();
    setState(() {});
  }
}
