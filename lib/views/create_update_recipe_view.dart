import 'package:flutter/material.dart';
import 'package:recipe_management/constants/routes.dart';

class CreateUpdateRecipeView extends StatefulWidget {
  const CreateUpdateRecipeView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateRecipeView> createState() => _CreateUpdateRecipeViewState();
}

class _CreateUpdateRecipeViewState extends State<CreateUpdateRecipeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(recipesRoute, (route) => false);
            },
            icon: const Icon(Icons.back_hand),
          ),
        ],
      ),
    );
  }
}
