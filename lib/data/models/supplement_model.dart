import 'package:equatable/equatable.dart';

class Supplement extends Equatable {
  final int? id;
  final String name;
  final String dosage;
  final String intakeTime;

  const Supplement({
    this.id,
    required this.name,
    required this.dosage,
    required this.intakeTime,
  });

  factory Supplement.fromJson(Map<String, dynamic> json) {
    String fullBody = json['body'] ?? '';
    String extractedDosage = '1 Capsule';
    String extractedTime = 'Anytime';

    if (fullBody.contains('||')) {
      final parts = fullBody.split('||');
      extractedDosage = parts[0].trim();
      extractedTime = parts[1].replaceAll('Take at', '').trim();
    }

    return Supplement(
      id: json['id'],
      name: json['title'] ?? 'Unknown',
      dosage: extractedDosage,
      intakeTime: extractedTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': name,
      'body': '$dosage || Take at $intakeTime',
    };
  }

  @override
  List<Object?> get props => [id, name, dosage, intakeTime];
}