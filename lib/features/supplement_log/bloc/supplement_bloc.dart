import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/dio_client.dart';
import '../../../data/models/supplement_model.dart';
import 'supplement_event.dart';
import 'supplement_state.dart';

class SupplementBloc extends Bloc<SupplementEvent, SupplementState> {
  final DioClient _dioClient;
  List<Supplement> _cachedList = [];

  SupplementBloc(this._dioClient) : super(SupplementInitial()) {
    on<LoadSupplements>(_onLoadSupplements);
    on<AddSupplement>(_onAddSupplement);
    on<UpdateSupplement>(_onUpdateSupplement);
    on<DeleteSupplement>(_onDeleteSupplement);
  }

  Future<void> _onLoadSupplements(LoadSupplements event, Emitter<SupplementState> emit) async {
    emit(SupplementLoading());
    try {
      _cachedList = await _dioClient.fetchSupplements();
      emit(SupplementLoaded(List.from(_cachedList)));
    } catch (e) {
      emit(SupplementError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onAddSupplement(AddSupplement event, Emitter<SupplementState> emit) async {
    emit(SupplementLoading());
    try {
      final APIResult = await _dioClient.createSupplement(event.supplement);

      final uniqueSupplement = Supplement(
        id: _cachedList.isEmpty ? 1 : (_cachedList.first.id ?? 0) + 1,
        name: APIResult.name,
        dosage: APIResult.dosage,
        intakeTime: APIResult.intakeTime,
      );

      _cachedList.insert(0, uniqueSupplement);
      emit(SupplementActionSuccess());
      emit(SupplementLoaded(List.from(_cachedList)));
    } catch (e) {
      emit(SupplementError("Failed to save schedule."));
      emit(SupplementLoaded(List.from(_cachedList)));
    }
  }

  Future<void> _onUpdateSupplement(UpdateSupplement event, Emitter<SupplementState> emit) async {
    emit(SupplementLoading());
    try {
      await _dioClient.updateSupplement(event.supplement);
      int idx = _cachedList.indexWhere((s) => s.id == event.supplement.id);
      if (idx != -1) {
        _cachedList[idx] = event.supplement;
      }
      emit(SupplementActionSuccess());
      emit(SupplementLoaded(List.from(_cachedList)));
    } catch (e) {
      emit(SupplementError("Failed to apply update."));
      emit(SupplementLoaded(List.from(_cachedList)));
    }
  }

  Future<void> _onDeleteSupplement(DeleteSupplement event, Emitter<SupplementState> emit) async {
    _cachedList.removeWhere((s) => s.id == event.id);
    emit(SupplementLoaded(List.from(_cachedList)));
    try {
      await _dioClient.deleteSupplement(event.id);
    } catch (e) {
      emit(SupplementError("Failed to completely wipe record from server context."));
    }
  }
}