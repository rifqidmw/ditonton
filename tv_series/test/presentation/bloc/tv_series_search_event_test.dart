import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_event.dart';

void main() {
  group('OnQueryChanged', () {
    test('props should contain query', () {
      // ignore: prefer_const_constructors
      final event = OnQueryChanged('breaking bad');
      expect(event.props, ['breaking bad']);
    });

    test('should support value equality', () {
      // ignore: prefer_const_constructors
      expect(OnQueryChanged('breaking bad'), OnQueryChanged('breaking bad'));
    });

    test('should not be equal with different queries', () {
      // ignore: prefer_const_constructors
      expect(
        // ignore: prefer_const_constructors
        OnQueryChanged('breaking bad') == OnQueryChanged('game of thrones'),
        false,
      );
    });
  });
}
