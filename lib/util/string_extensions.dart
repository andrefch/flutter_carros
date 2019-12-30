extension StringExtensions on String {
  String capitalize() {
    if (this.isNotEmpty) {
      if (this.length > 1) {
        return "${this[0].toUpperCase()}${this.substring(1)}";
      } else {
        return this.toUpperCase();
      }
    }
    return this;
  }
}