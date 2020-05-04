import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/repository/run_api_provider.dart';

class RunRepository {
  final RunApiProvider runApiProvider;

  RunRepository({
    @required this.runApiProvider
  }) : assert(runApiProvider != null);

  Future<Run> getRuns() async {
    return await runApiProvider.getRuns();
  }
}