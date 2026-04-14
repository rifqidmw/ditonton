import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/presentation/bloc/tv_series_search/tv_series_search_event.dart';

void main() {
  group('OnQueryChanged', () {
    test('props should contain query', () {
      const event = OnQueryChanged('breaking bad');
      expect(event.props, ['breaking bad']);
    });

    test('should support value equality', () {
      expect(
        const OnQueryChanged('breaking bad'),
        const OnQueryChanged('breaking bad'),
      );
    });

    test('should not be equal with different queries', () {
      expect(
        const OnQueryChanged('breaking bad') ==
            const OnQueryChanged('game of thrones'),
        false,
      );
    });
  });
}
