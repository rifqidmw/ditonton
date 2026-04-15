import 'package:core/error/exceptions.dart';
import 'package:core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exceptions', () {
    test('ServerException should have message', () {
      const message = 'Server error';
      final exception = ServerException(message);

      expect(exception.message, message);
    });

    test('DatabaseException should have message', () {
      const message = 'Database error';
      final exception = DatabaseException(message);

      expect(exception.message, message);
    });
  });

  group('Failures', () {
    test('ServerFailure should have message and props', () {
      const message = 'Server failure';
      const failure = ServerFailure(message);

      expect(failure.message, message);
      expect(failure.props, [message]);
    });

    test('ServerFailure should be equal when messages are same', () {
      const failure1 = ServerFailure('Error');
      const failure2 = ServerFailure('Error');

      expect(failure1, failure2);
    });

    test('DatabaseFailure should have message and props', () {
      const message = 'Database failure';
      const failure = DatabaseFailure(message);

      expect(failure.message, message);
      expect(failure.props, [message]);
    });

    test('DatabaseFailure should be equal when messages are same', () {
      const failure1 = DatabaseFailure('Error');
      const failure2 = DatabaseFailure('Error');

      expect(failure1, failure2);
    });

    test('ConnectionFailure should have message and props', () {
      const message = 'Connection failure';
      const failure = ConnectionFailure(message);

      expect(failure.message, message);
      expect(failure.props, [message]);
    });

    test('ConnectionFailure should be equal when messages are same', () {
      const failure1 = ConnectionFailure('Error');
      const failure2 = ConnectionFailure('Error');

      expect(failure1, failure2);
    });

    test('Different failure types should not be equal', () {
      const serverFailure = ServerFailure('Error');
      const databaseFailure = DatabaseFailure('Error');

      expect(serverFailure == databaseFailure, false);
    });
  });
}
