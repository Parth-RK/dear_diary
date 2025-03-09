part of 'trash_bloc.dart';

abstract class TrashState extends Equatable {
  const TrashState();
  
  @override
  List<Object?> get props => [];
}

class TrashInitial extends TrashState {}

class TrashLoading extends TrashState {}

class TrashLoaded extends TrashState {
  final List<JournalEntry> entries;
  
  const TrashLoaded(this.entries);
  
  @override
  List<Object?> get props => [entries];
}

class TrashError extends TrashState {
  final String message;
  
  const TrashError(this.message);
  
  @override
  List<Object?> get props => [message];
}
