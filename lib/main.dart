import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/services/dio_client.dart';
import 'features/supplement_log/bloc/supplement_bloc.dart';
import 'features/supplement_log/bloc/supplement_event.dart';
import 'features/supplement_log/views/screens/log_dashboard_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient();

    return BlocProvider(
      create: (_) => SupplementBloc(dioClient)..add(LoadSupplements()),
      child: MaterialApp(
        title: 'DailyDose Log',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: const LogDashboardScreen(),
      ),
    );
  }
}