import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/widgets/episode_card.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  const tEpisodeFull = Episode(
    id: 1,
    name: 'Pilot',
    episodeNumber: 1,
    seasonNumber: 1,
    overview: 'The show begins.',
    stillPath: '/still.jpg',
    voteAverage: 8.5,
    airDate: '2023-01-01',
  );

  const tEpisodeMinimal = Episode(
    id: 2,
    name: 'Empty Episode',
    episodeNumber: 2,
    seasonNumber: 1,
    overview: '',
    stillPath: null,
    voteAverage: 0,
    airDate: null,
  );

  testWidgets('renders episode number and name', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(EpisodeCard(episode: tEpisodeFull)),
    );
    expect(find.textContaining('Ep 1: Pilot'), findsOneWidget);
  });

  testWidgets('renders airDate when provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(EpisodeCard(episode: tEpisodeFull)),
    );
    expect(find.text('2023-01-01'), findsOneWidget);
  });

  testWidgets('does not render airDate when null', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(EpisodeCard(episode: tEpisodeMinimal)),
    );
    expect(find.text('2023-01-01'), findsNothing);
  });

  testWidgets('renders overview when not empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(EpisodeCard(episode: tEpisodeFull)),
    );
    expect(find.text('The show begins.'), findsOneWidget);
  });

  testWidgets('does not render overview when empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(EpisodeCard(episode: tEpisodeMinimal)),
    );
    expect(find.text('The show begins.'), findsNothing);
  });

  testWidgets('renders rating when voteAverage > 0', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(EpisodeCard(episode: tEpisodeFull)),
    );
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('8.5'), findsOneWidget);
  });

  testWidgets('does not render rating when voteAverage is 0', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(EpisodeCard(episode: tEpisodeMinimal)),
    );
    expect(find.byIcon(Icons.star), findsNothing);
  });

  testWidgets('shows placeholder when stillPath is null', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(EpisodeCard(episode: tEpisodeMinimal)),
    );
    expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
  });

  testWidgets('does not show placeholder when stillPath is provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(EpisodeCard(episode: tEpisodeFull)),
    );
    // CachedNetworkImage is shown instead of placeholder icon by default
    expect(find.byIcon(Icons.image_not_supported), findsNothing);
  });
}
