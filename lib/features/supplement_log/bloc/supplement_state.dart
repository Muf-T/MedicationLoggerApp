import 'package:equatable/equatable.dart';
import '../../../data/models/supplement_model.dart';

abstract class SupplementState extends Equatable {
  const SupplementState();

  @override
  List<Object?> get props => [];
}

class SupplementInitial extends SupplementState {}

class SupplementLoading extends SupplementState {}

class SupplementLoaded extends SupplementState {
  final List<Supplement> supplements;
  const SupplementLoaded(this.supplements);

  @override
  List<Object?> get props => [supplements];
}

class SupplementActionSuccess extends SupplementState {}

class SupplementError extends SupplementState {
  final String message;
  const SupplementError(this.message);

  @override
  List<Object?> get props => [message];
}