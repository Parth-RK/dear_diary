part of 'journal_bloc.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

class LoadJournalEntries extends JournalEvent {}

class AddJournalEntryEvent extends JournalEvent {
  final JournalEntry entry;

  const AddJournalEntryEvent(this.entry);

  @override
  List<Object?> get props => [entry];
}

class UpdateJournalEntryEvent extends JournalEvent {
  final JournalEntry entry;

  const UpdateJournalEntryEvent(this.entry);

  @override
  List<Object?> get props => [entry];
}

class DeleteJournalEntryEvent extends JournalEvent {
  final String id;

  const DeleteJournalEntryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetJournalEntryEvent extends JournalEvent {
  final String id;

  const GetJournalEntryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MoveJournalEntryToTrash extends JournalEvent {
  final String id;

  const MoveJournalEntryToTrash(this.id);

  @override
  List<Object?> get props => [id];
}

class RestoreJournalEntryEvent extends JournalEvent {
  final String id;

  const RestoreJournalEntryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteJournalEntryPermanently extends JournalEvent {
  final String id;

  const DeleteJournalEntryPermanently(this.id);

  @override
  List<Object?> get props => [id];
}

class EmptyTrash extends JournalEvent {}
