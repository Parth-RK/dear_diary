import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/domain/usecases/add_journal_entry.dart';
import 'package:dear_diary/domain/usecases/get_journal_entries.dart';
import 'package:dear_diary/domain/usecases/update_journal_entry.dart';
import 'package:dear_diary/domain/usecases/restore_journal_entry.dart';
import 'package:dear_diary/domain/usecases/journal_entry_deletion.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final GetJournalEntries getJournalEntries;
  final AddJournalEntry addJournalEntry;
  final UpdateJournalEntry updateJournalEntry;
  final RestoreJournalEntry restoreJournalEntryUseCase;
  final JournalEntryDeletion journalEntryDeletion;

  JournalBloc({
    required this.getJournalEntries,
    required this.addJournalEntry,
    required this.updateJournalEntry,
    required this.restoreJournalEntryUseCase,
    required this.journalEntryDeletion,
  }) : super(JournalInitial()) {
    on<LoadJournalEntries>(_onLoadJournalEntries);
    on<AddJournalEntryEvent>(_onAddJournalEntry);
    on<UpdateJournalEntryEvent>(_onUpdateJournalEntry);
    on<DeleteJournalEntryEvent>(_onDeleteJournalEntry);
    on<GetJournalEntryEvent>(_onGetJournalEntry);
    on<MoveJournalEntryToTrash>(_onMoveJournalEntryToTrash);
    on<RestoreJournalEntryEvent>(_onRestoreJournalEntry);
    on<DeleteJournalEntryPermanently>(_onDeleteJournalEntryPermanently);
    on<EmptyTrash>(_onEmptyTrash);
  }

  Future<void> _onLoadJournalEntries(
    LoadJournalEntries event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    try {
      final entries = await getJournalEntries();
      emit(JournalLoaded(entries));
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }

  Future<void> _onAddJournalEntry(
    AddJournalEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await addJournalEntry(event.entry);
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }

  Future<void> _onUpdateJournalEntry(
    UpdateJournalEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await updateJournalEntry(event.entry);
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }

  Future<void> _onDeleteJournalEntry(
    DeleteJournalEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await journalEntryDeletion.moveToTrash(event.id);
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }
  
  Future<void> _onGetJournalEntry(
    GetJournalEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    try {
      final entry = await getJournalEntries.getById(event.id);
      if (entry != null) {
        emit(JournalEntryLoaded(entry));
      } else {
        emit(const JournalError('Entry not found'));
      }
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }
  
  Future<void> _onMoveJournalEntryToTrash(
    MoveJournalEntryToTrash event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await journalEntryDeletion.moveToTrash(event.id);
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }
  
  Future<void> _onRestoreJournalEntry(
    RestoreJournalEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await restoreJournalEntryUseCase(event.id);
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }
  
  Future<void> _onDeleteJournalEntryPermanently(
    DeleteJournalEntryPermanently event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await journalEntryDeletion.deletePermanently(event.id);
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }
  
  Future<void> _onEmptyTrash(
    EmptyTrash event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await journalEntryDeletion.emptyTrash();
      add(LoadJournalEntries());
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }
}
