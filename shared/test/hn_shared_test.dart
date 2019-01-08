// import 'package:hn_shared/hn_shared.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    bool awesome;

    setUp(() {
      awesome = true;
    });

    test('First Test', () {
      expect(awesome, isTrue);
    });
  });
}
