import 'package:flutter/material.dart';
import 'package:recipe_management/constants/routes.dart';
import 'package:recipe_management/views/create_update_recipe_view.dart';
import 'package:recipe_management/views/home_page.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
        recipesRoute: (context) => const HomePage(),
        createOrUpdateRecipeRoute: (context) => const CreateUpdateRecipeView(),
      },
    );
  }
}
