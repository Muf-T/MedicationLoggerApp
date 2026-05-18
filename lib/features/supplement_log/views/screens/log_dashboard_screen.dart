import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/supplement_bloc.dart';
import '../../bloc/supplement_event.dart';
import '../../bloc/supplement_state.dart';
import '../widgets/supplement_title.dart';
import 'add_edit_supplement_screen.dart';

class LogDashboardScreen extends StatelessWidget {
  const LogDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyDose Log', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditSupplementScreen(bloc: context.read<SupplementBloc>()),
            ),
          );
        },
      ),
      body: BlocListener<SupplementBloc, SupplementState>(
        listener: (context, state) {
          if (state is SupplementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        child: BlocBuilder<SupplementBloc, SupplementState>(
          builder: (context, state) {
            if (state is SupplementInitial || state is SupplementLoading && _isListEmpty(state)) {
              return const Center(child: CircularProgressIndicator(color: Colors.teal));
            } else if (state is SupplementLoaded) {
              if (state.supplements.isEmpty) {
                return const Center(child: Text("Your tracker cabinet is empty. Log structural data +"));
              }
              return RefreshIndicator(
                onRefresh: () async => context.read<SupplementBloc>().add(LoadSupplements()),
                child: ListView.builder(
                  itemCount: state.supplements.length,
                  itemBuilder: (context, idx) => SupplementTile(supplement: state.supplements[idx]),
                ),
              );
            }
            return const Center(child: Text("State initialization failed or connection lost."));
          },
        ),
      ),
    );
  }

  bool _isListEmpty(SupplementState state) {
    return state is! SupplementLoaded;
  }
}