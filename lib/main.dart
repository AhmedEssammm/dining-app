import 'package:dining_app/cubits/basket/basket_cubit.dart';
import 'package:dining_app/cubits/favorites/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/auth/auth_cubit.dart';
import 'screens/login/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DiningApp());
}

class DiningApp extends StatelessWidget {
  const DiningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => FavoritesCubit()),
        BlocProvider(create: (_) => BasketCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dining App',
        theme: AppTheme.theme,
        home: const LoginScreen(),
      ),
    );
  }
}
