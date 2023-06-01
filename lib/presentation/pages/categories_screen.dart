import 'package:flutter/material.dart';
import 'package:meals_app/data/dataSources/local/dummy_data.dart';
import 'package:meals_app/domain/models/category_model.dart';
import 'package:meals_app/domain/models/meals_model.dart';
import 'package:meals_app/presentation/pages/meals_screen.dart';
import 'package:meals_app/presentation/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    // required this.onToggleMealFavoriteStatus,
    required this.availableMeals,
  });

  // final void Function(MealsModel meal) onToggleMealFavoriteStatus;
  final List<MealsModel> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// with SingleTickerProviderStateMixin(une animation) & TickerProviderStateMixin(plusieurs animation) -> les deux ne sont pas souvent utiliser
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // late -> cette variable aura une value quand elle sera utiliser pour la 1ère fois
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    // supprimer l'annimation de la mémoire de l'appareil une fois que ce widget est remove
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, CategoryModel category) {
    // where => renvoi une new list qui ne contient que les elt qui repondent à une certaine conditions
    /// true si la condition et vérifier et false si la condition n'est pas vérifier
    /// ce cas la fun renvoie true si le meal appartient à la catégory selectioné
    final filterdMeals = widget.availableMeals // dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filterdMeals,
          // onToggleMealFavoriteStatus: onToggleMealFavoriteStatus,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // GridView -> si vous n'avez pas beaucoup d'elt à afficher
    // GridView.builder -> et autres si vous avez many d'elt to show
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // deux colonnes
          childAspectRatio: 3 / 2, // taille des elt(grids)
          crossAxisSpacing: 20, // espacement horizontal colonnes
          mainAxisSpacing: 20, // espacement vertical colonnes
        ),
        children: [
          // ...availableCategories
          //     .map((category) => CategoryGridItem(category: category))
          //     .toList(),
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () => _selectCategory(context, category),
            ),
        ],
      ),
      builder: (context, child) => Padding(
        // start value is 0 => 0*100 = 0
        padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
        child: child,
      ),
    );
  }
}
