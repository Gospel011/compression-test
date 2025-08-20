mixin ImageMixin {
  String formatFileSize(double size) {
    String sizeStr = '';
    print(size);

    if (size >= 1024 && size <= 1024 * 1024) {
      sizeStr = "${(size / 1024).toStringAsFixed(2)} KB";
    } else if (size >= 1024 * 1024 && size <= 1024 * 1024 * 1024) {
      sizeStr = "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else {
      sizeStr = "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
    }
    return sizeStr;
  }
}