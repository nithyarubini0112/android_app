
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MealPlanner(),
  ));
}

class MealPlanner extends StatefulWidget {
  const MealPlanner({super.key});

  @override
  State<MealPlanner> createState() => _MealPlannerState();
}

class _MealPlannerState extends State<MealPlanner> {
  String category = 'All';

  final List<Map<String, dynamic>> meals = [
    {'name': 'Idli', 'category': 'Breakfast', 'emoji': '🍚'},
    {'name': 'Dosa', 'category': 'Breakfast', 'emoji': '🥞'},
    {'name': 'Veg Rice', 'category': 'Lunch', 'emoji': '🍛'},
    {'name': 'Paneer Wrap', 'category': 'Lunch', 'emoji': '🌯'},
    {'name': 'Pasta', 'category': 'Dinner', 'emoji': '🍝'},
    {'name': 'Fruit Salad', 'category': 'Snacks', 'emoji': '🍓'},
  ];

  final List<String> shoppingList = ['Rice', 'Milk', 'Tomato'];
  final Set<String> checkedItems = {};

  final Map<String, String> weeklyPlan = {};

  @override
  Widget build(BuildContext context) {
    final filteredMeals = category == 'All'
        ? meals
        : meals.where((m) => m['category'] == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🥗 Smart Meal Planner'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan your meals, eat better!',
                  style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                const Text('Food Categories',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  children: [
                    'All',
                    'Breakfast',
                    'Lunch',
                    'Dinner',
                    'Snacks'
                  ].map((c) {
                    return ChoiceChip(
                      label: Text(c),
                      selected: category == c,
                      onSelected: (_) {
                        setState(() => category = c);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Meal Ideas',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredMeals.length,
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisExtent: 175,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final meal = filteredMeals[index];

                    return Card(
                      color: Colors.green.shade50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(meal['emoji'],
                              style: const TextStyle(fontSize: 38)),
                          Text(
                            meal['name'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(meal['category']),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                weeklyPlan[meal['category']] =
                                    meal['name'];
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${meal['name']} added to meal plan'),
                                ),
                              );
                            },
                            child: const Text('Add to plan'),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 25),
                const Text(
                  'My Meal Plan',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (weeklyPlan.isEmpty)
                  const Text('No meals planned yet.')
                else
                  ...weeklyPlan.entries.map(
                    (entry) => ListTile(
                      leading: const Icon(Icons.restaurant),
                      title: Text(entry.value),
                      subtitle: Text(entry.key),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            weeklyPlan.remove(entry.key);
                          });
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 25),
                const Text(
                  'Shopping Checklist',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                ...shoppingList.map(
                  (item) => CheckboxListTile(
                    title: Text(item),
                    value: checkedItems.contains(item),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          checkedItems.add(item);
                        } else {
                          checkedItems.remove(item);
                        }
                      });
                    },
                  ),
                ),

                Center(
                  child: Text(
                    '${checkedItems.length}/${shoppingList.length} items completed',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
