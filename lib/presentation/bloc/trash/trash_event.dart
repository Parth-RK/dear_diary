part of 'trash_bloc.dart';

abstract class TrashEvent extends Equatable {
  const TrashEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrashEntries extends TrashEvent {}

class RestoreTrashEntry extends TrashEvent {
  final String id;

  const RestoreTrashEntry(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteTrashEntryPermanently extends TrashEvent {
  final String id;

  const DeleteTrashEntryPermanently(this.id);

  @override
  List<Object?> get props => [id];
}

class EmptyTrashEvent extends TrashEvent {}
