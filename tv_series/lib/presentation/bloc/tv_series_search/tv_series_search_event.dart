import 'package:equatable/equatable.dart';

abstract class TVSeriesSearchEvent extends Equatable {
  const TVSeriesSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends TVSeriesSearchEvent {
  final String query;

  const OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
