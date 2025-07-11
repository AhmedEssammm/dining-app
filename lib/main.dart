import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/auth/auth_cubit.dart';
import 'screens/login/login_screen.dart';

void main() {
  runApp(const DiningApp());
}

class DiningApp extends StatelessWidget {
  const DiningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dining App',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
