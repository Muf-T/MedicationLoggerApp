import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/supplement_model.dart';
import '../../bloc/supplement_bloc.dart';
import '../../bloc/supplement_event.dart';
import '../../bloc/supplement_state.dart';

class AddEditSupplementScreen extends StatefulWidget {
  final Supplement? supplement;
  final SupplementBloc bloc;

  const AddEditSupplementScreen({super.key, this.supplement, required this.bloc});

  @override
  State<AddEditSupplementScreen> createState() => _AddEditSupplementScreenState();
}

class _AddEditSupplementScreenState extends State<AddEditSupplementScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _timeController;

  bool get isEditMode => widget.supplement != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplement?.name ?? '');
    _dosageController = TextEditingController(text: widget.supplement?.dosage ?? '');
    _timeController = TextEditingController(text: widget.supplement?.intakeTime ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final supplementData = Supplement(
      id: widget.supplement?.id,
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      intakeTime: _timeController.text.trim(),
    );

    if (isEditMode) {
      widget.bloc.add(UpdateSupplement(supplementData));
    } else {
      widget.bloc.add(AddSupplement(supplementData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Scaffold(
        appBar: AppBar(title: Text(isEditMode ? 'Modify Entry' : 'Log Supplement')),
        body: BlocConsumer<SupplementBloc, SupplementState>(
          listener: (context, state) {
            if (state is SupplementActionSuccess) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is SupplementLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.teal));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Supplement Name', border: OutlineInputBorder()),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _dosageController,
                      decoration: const InputDecoration(labelText: 'Dosage', border: OutlineInputBorder()),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Enter dosage metric' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _timeController,
                      decoration: const InputDecoration(labelText: 'Intake Schedule', border: OutlineInputBorder()),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Enter time parameter' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        onPressed: _submit,
                        child: Text(isEditMode ? 'Update' : 'Save Log', style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}