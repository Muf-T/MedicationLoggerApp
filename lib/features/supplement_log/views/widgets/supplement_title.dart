import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/supplement_model.dart';
import '../../bloc/supplement_bloc.dart';
import '../../bloc/supplement_event.dart';
import '../screens/add_edit_supplement_screen.dart';

class SupplementTile extends StatelessWidget {
  final Supplement supplement;

  const SupplementTile({super.key, required this.supplement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.withOpacity(0.1),
          child: const Icon(Icons.medication, color: Colors.teal),
        ),
        title: Text(
          supplement.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text("Dosage: ${supplement.dosage}\nTime: ${supplement.intakeTime}"),
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditSupplementScreen(supplement: supplement, bloc: context.read<SupplementBloc>()),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                if (supplement.id != null) {
                  context.read<SupplementBloc>().add(DeleteSupplement(supplement.id!));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}