# Ditonton - TV Series App

[![Flutter CI](https://github.com/rifqidmw/ditonton/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/rifqidmw/ditonton/actions/workflows/flutter_ci.yml)
[![codecov](https://codecov.io/gh/rifqidmw/ditonton/branch/main/graph/badge.svg)](https://codecov.io/gh/rifqidmw/ditonton)

A Flutter application for browsing TV series with clean architecture implementation.

## Features

✅ Browse popular, top-rated, and on-the-air TV series  
✅ Search TV series  
✅ View detailed information including seasons and episodes  
✅ Manage watchlist (add/remove)  
✅ Offline support with local database  
✅ Network logging with Dio interceptor  

## Architecture

This project implements **Clean Architecture** with three main layers:

```
lib/
├── core/                 # Core utilities and DI
├── features/
│   └── tv_series/
│       ├── data/        # Data sources, models, repositories
│       ├── domain/      # Entities, repositories, use cases
│       └── presentation/ # UI, BLoC, pages, widgets
```

## Tech Stack

- **State Management**: BLoC (flutter_bloc)
- **Navigation**: go_router
- **Network**: Dio with pretty_dio_logger
- **Local Storage**: sqflite
- **Dependency Injection**: get_it
- **Functional Programming**: dartz
- **Testing**: mockito, mocktail, bloc_test

## Getting Started

### Prerequisites

- Flutter SDK 3.10.8 or higher
- Dart SDK 3.10.8 or higher

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/ditonton.git
cd ditonton

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Testing

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
# Using script (generates HTML report)
./scripts/coverage.sh

# Or manually
flutter test --coverage
```

### Run widget tests only
```bash
flutter test test/features/tv_series/presentation/
```

### Run integration tests (requires device/emulator)
```bash
flutter test integration_test/
```

### Coverage Requirements
- **Minimum Coverage**: 70%
- CI/CD will fail if coverage drops below this threshold

## CI/CD

This project uses GitHub Actions for automated testing:

- ✅ Code formatting check
- ✅ Static analysis (flutter analyze)
- ✅ Unit tests
- ✅ Widget tests
- ✅ Code coverage validation (minimum 70%)
- ✅ APK build on main branch

## Project Structure

```
ditonton/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── database/
│   │   ├── di/
│   │   └── error/
│   ├── features/
│   │   └── tv_series/
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   ├── models/
│   │       │   └── repositories/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   ├── repositories/
│   │       │   └── usecases/
│   │       └── presentation/
│   │           ├── bloc/
│   │           ├── pages/
│   │           └── widgets/
│   └── main.dart
├── test/                    # Unit & Widget tests
├── integration_test/        # Integration tests
└── scripts/                 # Helper scripts
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Ensure tests pass and coverage is ≥70%
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## License

This project is for educational purposes (Dicoding Submission).

## Author

- **Your Name** - [@YOUR_USERNAME](https://github.com/YOUR_USERNAME)

---

**Note**: Replace `YOUR_USERNAME` with your actual GitHub username in the badges and links above.

