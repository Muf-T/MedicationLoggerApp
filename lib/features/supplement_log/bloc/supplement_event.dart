import 'package:equatable/equatable.dart';
import '../../../data/models/supplement_model.dart';

abstract class SupplementEvent extends Equatable {
  const SupplementEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupplements extends SupplementEvent {}

class AddSupplement extends SupplementEvent {
  final Supplement supplement;
  const AddSupplement(this.supplement);

  @override
  List<Object?> get props => [supplement];
}

class UpdateSupplement extends SupplementEvent {
  final Supplement supplement;
  const UpdateSupplement(this.supplement);

  @override
  List<Object?> get props => [supplement];
}

class DeleteSupplement extends SupplementEvent {
  final int id;
  const DeleteSupplement(this.id);

  @override
  List<Object?> get props => [id];
}