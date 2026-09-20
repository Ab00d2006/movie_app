import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/watch_list_cubit/watch_list_cubit.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WatchListCubit()..loadWatchList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xff242A32),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff0296E5),
            brightness: Brightness.dark,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
