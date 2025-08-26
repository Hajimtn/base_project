class ReponseTotalList<T> {
  ReponseTotalList(
      {required this.totalRows,
      required this.dataList,
      this.value1,
      this.value2});
  factory ReponseTotalList.fromJson(Map<String, dynamic>? json,
          T Function(Map<String, dynamic> json) fromJson,
          {String keyDataList = 'dataList',
          String? keyValue1,
          String? keyValue2}) =>
      json == null
          ? ReponseTotalList<T>(totalRows: 0, dataList: <T>[])
          : ReponseTotalList<T>(
              totalRows: (json['totalRows'] as int?) ?? 0,
              dataList: json[keyDataList] == null
                  ? json['dataList'] == null
                      ? <T>[]
                      : (json['dataList'] as List<dynamic>)
                          .map((dynamic e) => fromJson(e))
                          .toList()
                  : (json[keyDataList] as List<dynamic>)
                      .map((dynamic e) => fromJson(e))
                      .toList(),
              value1: json[keyValue1] as num?,
              value2: json[keyValue2] as num?,
            );

  final int totalRows;
  final List<T> dataList;
  final num? value1;
  final num? value2;
}
