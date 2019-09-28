import 'package:health_app/model/postage_index.dart';

class Postage {
  final String type;
  final int level;

  Postage(this.type, this.level);

  int get index {
    if (level == null) return 0;
    return level + 3;
  }

  int get imageIndex {
    if (level == 0) {
      return 0;
    } else {
      if (type == "left") {
        return -level;
      } else {
        return level;
      }
    }
  }

  String getCorrectingMessage() {
    if (level != null && level != 0) {
      return "Сядьте прямее";
    } else {
      return "";
    }
  }

  PostageIndex getPostageIndex() {
    return new PostageIndex(index);
  }
}
