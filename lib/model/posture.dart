import 'dart:math';

class Postage {
  final Point leftShoulder;
  final Point rightShoulder;
  final Point spineTop;
  final Point spineBottom;

  Postage(
      this.leftShoulder, this.rightShoulder, this.spineTop, this.spineBottom);

  int get index {
    return -2;
  }
}
