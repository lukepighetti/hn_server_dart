import 'package:hn_aqueduct/channel.dart';

import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:hn_aqueduct/hn_aqueduct.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

/// A testing harness for hn_aqueduct.
class Harness extends TestHarness<HnAqueductChannel> {
  @override
  Future onSetUp() async {}

  @override
  Future onTearDown() async {}
}
