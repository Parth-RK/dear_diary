import 'package:get_it/get_it.dart';
import 'package:dear_diary/data/datasources/local/hive_journal_datasource.dart';
import 'package:dear_diary/data/repositories/journal_repository_impl.dart';
import 'package:dear_diary/domain/repositories/journal_repository.dart';
import 'package:dear_diary/domain/usecases/add_journal_entry.dart';
import 'package:dear_diary/domain/usecases/get_journal_entries.dart';
import 'package:dear_diary/domain/usecases/restore_journal_entry.dart';
import 'package:dear_diary/domain/usecases/update_journal_entry.dart';
import 'package:dear_diary/domain/usecases/journal_entry_deletion.dart';
import 'package:dear_diary/app/theme/theme_cubit.dart';
import 'package:dear_diary/presentation/bloc/journal/journal_bloc.dart';
import 'package:dear_diary/presentation/bloc/trash/trash_bloc.dart';
import 'package:dear_diary/utils/storage_utils.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Utils
  sl.registerSingleton<StorageUtils>(StorageUtils());
  
  // Data sources
  final dataSource = await HiveJournalDataSource.create();
  sl.registerSingleton<HiveJournalDataSource>(dataSource);
  
  // Repositories
  sl.registerSingleton<JournalRepository>(
    JournalRepositoryImpl(
      localDataSource: sl<HiveJournalDataSource>(),
      storageUtils: sl<StorageUtils>(),
    ),
  );
  
  // Use cases
  sl.registerSingleton<GetJournalEntries>(GetJournalEntries(sl<JournalRepository>()));
  sl.registerSingleton<AddJournalEntry>(AddJournalEntry(sl<JournalRepository>()));
  sl.registerSingleton<UpdateJournalEntry>(UpdateJournalEntry(sl<JournalRepository>()));
  sl.registerSingleton<RestoreJournalEntry>(RestoreJournalEntry(sl<JournalRepository>()));
  sl.registerSingleton<JournalEntryDeletion>(JournalEntryDeletion(sl<JournalRepository>()));
  
  // Cubits
  sl.registerSingleton<ThemeCubit>(ThemeCubit());
  
  // Blocs
  sl.registerFactory<JournalBloc>(() => JournalBloc(
    getJournalEntries: sl<GetJournalEntries>(),
    addJournalEntry: sl<AddJournalEntry>(),
    updateJournalEntry: sl<UpdateJournalEntry>(),
    restoreJournalEntryUseCase: sl<RestoreJournalEntry>(),
    journalEntryDeletion: sl<JournalEntryDeletion>(),
  ));
  
  sl.registerFactory<TrashBloc>(() => TrashBloc(
    getJournalEntries: sl<GetJournalEntries>(),
    restoreJournalEntry: sl<RestoreJournalEntry>(),
    journalEntryDeletion: sl<JournalEntryDeletion>(),
  ));
}
