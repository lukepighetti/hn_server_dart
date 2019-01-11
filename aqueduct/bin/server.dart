import 'package:hn_aqueduct/hn_aqueduct.dart';
import 'dart:io' show Platform;
import 'dart:math' show max;

Future main() async {
  /// Get properties from environment variables
  final port = int.parse(Platform.environment['PORT'] ?? "8080");

  final instances = int.parse(
    Platform.environment['INSTANCES'] ?? "${Platform.numberOfProcessors ~/ 2}",
  );

  /// Initialize app
  final app = Application<HnAqueductChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = port;

  await app.start(numberOfInstances: max(instances, 1));

  print("Application started on port ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
