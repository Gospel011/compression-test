import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MyImageWidget extends StatelessWidget {
  const MyImageWidget({super.key, required this.image, this.size});
  final XFile image;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: image.readAsBytes(),
          builder: (context, snapsot) {
            if (snapsot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator.adaptive();
            }

            if (snapsot.hasData == false) return SizedBox.shrink();

            return Image.memory(
              snapsot.data!,
              fit: BoxFit.cover,
              width: size,
              height: size,
            );
          },
        ),
      ),
    );
  }
}
