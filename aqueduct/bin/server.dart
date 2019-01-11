import 'package:hn_aqueduct/hn_aqueduct.dart';
import 'dart:io' show Platform;

Future main() async {
  final port = int.parse(Platform.environment['PORT'] ?? "8080");

  final app = Application<HnAqueductChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = port;

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print("Application started on port ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
