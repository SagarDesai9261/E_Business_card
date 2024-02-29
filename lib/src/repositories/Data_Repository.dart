import 'dart:async';
import 'package:meta/meta.dart';
import 'repositories.dart';

class DataRepository {
  final DataApiClient dataApiClient;
  DataRepository({@required this.dataApiClient})
      : assert(dataApiClient != null);

  Future<List<Object>> getData() async {
    return await dataApiClient.fetchData();
  }
}
