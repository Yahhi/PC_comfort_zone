class PostageIndex {
  static const TABLE_NAME = "posture_rates";
  static const COLUMN_RATE = "rate";
  static const COLUMN_ID = "id";
  static const COLUMN_FIXED_AT = "fixed_at";
  static const COLUMNS = [COLUMN_ID, COLUMN_FIXED_AT, COLUMN_RATE];

  static const CREATE_EXPRESSION = '''
            create table $TABLE_NAME ( 
              $COLUMN_ID integer primary key autoincrement, 
              $COLUMN_FIXED_AT String not null,
              $COLUMN_RATE int not null)
            ''';

  int postureRate;
  DateTime fixedAt;

  PostageIndex(this.postureRate) : fixedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      COLUMN_FIXED_AT: fixedAt.toIso8601String(),
      COLUMN_RATE: postureRate,
    };
    return map;
  }

  PostageIndex.fromMap(Map<String, dynamic> map)
      : postureRate = map[COLUMN_RATE],
        fixedAt = DateTime.parse(map[COLUMN_FIXED_AT]);
}
