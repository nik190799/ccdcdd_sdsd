import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const CalorieDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalorieDashboardScreen extends StatefulWidget {
  const CalorieDashboardScreen({super.key});

  @override
  State<CalorieDashboardScreen> createState() => _CalorieDashboardScreenState();
}

class _CalorieDashboardScreenState extends State<CalorieDashboardScreen> {
  // Hardcoded data for different days (only 2 shown here)
  final List<DateTime> _dates = [
    DateTime.now(),
    DateTime.now().subtract(const Duration(days: 1)),
  ];
  int _selectedDayIndex = 0;
  static const int calorieGoal = 2000;

  // Data: For demo, index 0=today, 1=yesterday.
  final List<Map<String, dynamic>> _dataByDay = [
    {
      "total": 1700,
      "meals": {
        "Breakfast": 350,
        "Lunch": 560,
        "Dinner": 620,
        "Snacks": 170,
      }
    },
    {
      "total": 2300,
      "meals": {
        "Breakfast": 400,
        "Lunch": 730,
        "Dinner": 910,
        "Snacks": 260,
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedData = _dataByDay[_selectedDayIndex];
    final meals = selectedData["meals"] as Map<String, int>;
    final total = selectedData["total"] as int;
    final progress = (total / calorieGoal).clamp(0.0, 1.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Dashboard'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _selectedDayIndex < _dates.length - 1
                          ? () {
                              setState(() {
                                _selectedDayIndex++;
                              });
                            }
                          : null,
                    ),
                    Text(
                      _selectedDayIndex == 0
                          ? "Today"
                          : "${_dates[_selectedDayIndex].month.toString().padLeft(2, '0')}-${_dates[_selectedDayIndex].day.toString().padLeft(2, '0')}-${_dates[_selectedDayIndex].year}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Next
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _selectedDayIndex > 0
                          ? () {
                              setState(() {
                                _selectedDayIndex--;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Calories",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15, color: Colors.green),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "$total",
                                  style: const TextStyle(
                                      fontSize: 37,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.green),
                                ),
                                Text(
                                  " / $calorieGoal kcal",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green[800]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.green.shade100,
                                color: Colors.green,
                                strokeWidth: 8,
                              ),
                              Center(
                                child: Text(
                                  "${(progress * 100).toInt()}%",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Meal Breakdown",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemCount: meals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final mealName = meals.keys.elementAt(idx);
                      final cals = meals[mealName]!;
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                        color: Colors.white,
                        elevation: 1,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: Icon(
                              mealName == "Breakfast"
                                  ? Icons.free_breakfast
                                  : mealName == "Lunch"
                                      ? Icons.lunch_dining
                                      : mealName == "Dinner"
                                          ? Icons.dinner_dining
                                          : Icons.icecream,
                              color: Colors.green,
                            ),
                          ),
                          title: Text(
                            mealName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          subtitle: Text(
                            "$cals kcal",
                            style: const TextStyle(
                                color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () {
                              // Placeholder: Could open add-food dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Add Food to $mealName (demo only)")));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.green.shade800,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.white, size: 30),
                      const SizedBox(width: 10),
                      Text(
                        "$total kcal",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Goal: $calorieGoal",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
