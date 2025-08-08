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
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
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
            const SizedBox(height: 22),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Calorie Intake",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                    const SizedBox(height: 11),
                    Row(
                      children: [
                        Text(
                          "$total",
                          style: const TextStyle(
                              fontSize: 38, fontWeight: FontWeight.w900, color: Colors.green),
                        ),
                        const Text(
                          " / $calorieGoal kcal",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.green.shade100,
                      color: Colors.green,
                      minHeight: 11,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
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
                    color: Colors.green[50],
                    elevation: 1,
                    child: ListTile(
                      title: Text(
                        mealName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16, color: Colors.green),
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
    );
  }
}
