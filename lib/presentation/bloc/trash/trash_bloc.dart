import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/domain/usecases/get_journal_entries.dart';
import 'package:dear_diary/domain/usecases/restore_journal_entry.dart';
import 'package:dear_diary/domain/usecases/journal_entry_deletion.dart';

part 'trash_event.dart';
part 'trash_state.dart';

class TrashBloc extends Bloc<TrashEvent, TrashState> {
  final GetJournalEntries getJournalEntries;
  final RestoreJournalEntry restoreJournalEntry;
  final JournalEntryDeletion journalEntryDeletion;

  TrashBloc({
    required this.getJournalEntries,
    required this.restoreJournalEntry,
    required this.journalEntryDeletion,
  }) : super(TrashInitial()) {
    on<LoadTrashEntries>(_onLoadTrashEntries);
    on<RestoreTrashEntry>(_onRestoreTrashEntry);
    on<DeleteTrashEntryPermanently>(_onDeleteTrashEntryPermanently);
    on<EmptyTrashEvent>(_onEmptyTrash);
  }

  Future<void> _onLoadTrashEntries(
    LoadTrashEntries event,
    Emitter<TrashState> emit,
  ) async {
    emit(TrashLoading());
    try {
      final entries = await getJournalEntries.getDeletedEntries();
      emit(TrashLoaded(entries));
    } catch (e) {
      emit(TrashError(e.toString()));
    }
  }

  Future<void> _onRestoreTrashEntry(
    RestoreTrashEntry event,
    Emitter<TrashState> emit,
  ) async {
    try {
      await restoreJournalEntry(event.id);
      add(LoadTrashEntries());
    } catch (e) {
      emit(TrashError(e.toString()));
    }
  }

  Future<void> _onDeleteTrashEntryPermanently(
    DeleteTrashEntryPermanently event,
    Emitter<TrashState> emit,
  ) async {
    try {
      await journalEntryDeletion.deletePermanently(event.id);
      add(LoadTrashEntries());
    } catch (e) {
      emit(TrashError(e.toString()));
    }
  }

  Future<void> _onEmptyTrash(
    EmptyTrashEvent event,
    Emitter<TrashState> emit,
  ) async {
    try {
      await journalEntryDeletion.emptyTrash();
      add(LoadTrashEntries());
    } catch (e) {
      emit(TrashError(e.toString()));
    }
  }
}
