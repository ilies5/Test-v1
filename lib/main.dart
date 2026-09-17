import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'goals_page.dart';

void main() {
  runApp(const LifeManagerApp());
}

class LifeManagerApp extends StatelessWidget {
  const LifeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Life Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const HomePage(),
    );
  }
}

class Task {
  String title;
  bool completed;

  Task({
    required this.title,
    this.completed = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Task> tasks = [];
  List<Goal> goals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks') ?? [];

    setState(() {
      tasks = savedTasks.map((item) {
        final parts = item.split('|');

        return Task(
          title: parts[0],
          completed: parts.length > 1 && parts[1] == 'true',
        );
      }).toList();

      isLoading = false;
    });
  }
  Future<void> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGoals = prefs.getStringList("goals") ?? [];

    setState(() {
      goals = savedGoals.map((item) {
        final parts = item.split("|");

        return Goal(
          title: parts[0],
          progress: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
        );
      }).toList();
    });
  }
  Future<void> saveGoals() async {
    final prefs = await SharedPreferences.getInstance();

    final savedGoals = goals.map((goal) {
      return "${goal.title}|${goal.progress}";
    }).toList();

    await prefs.setStringList("goals", savedGoals);
  }


  Future<void> addGoal(String title) async {
    if (title.trim().isEmpty) return;

    setState(() {
      goals.add(Goal(title: title.trim()));
    });

    await saveGoals();
  }


  Future<void> updateGoal(int index, int progress) async {
    setState(() {
      goals[index].progress = progress.clamp(0, 100);
    });

    await saveGoals();
  }

  Future<void> deleteGoal(int index) async {
    setState(() {
      goals.removeAt(index);
    });

    await saveGoals();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTasks = tasks.map((task) {
      return '${task.title}|${task.completed}';
    }).toList();

    await prefs.setStringList('tasks', savedTasks);
  }

  Future<void> addTask(String title) async {
    setState(() {
      tasks.add(Task(title: title));
    });

    await saveTasks();
  }

  Future<void> toggleTask(int index) async {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
    });

    await saveTasks();
  }

  Future<void> deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index);
    });

    await saveTasks();
  }

  int get completedTasks {
    return tasks.where((task) => task.completed).length;
  }

  double get progress {
    if (tasks.isEmpty) return 0;
    return completedTasks / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final pages = [
      DashboardPage(
        tasks: tasks,
        completedTasks: completedTasks,
        progress: progress,
        goals: goals,
        onToggle: toggleTask,
      ),
      TasksPage(
        tasks: tasks,
        onAdd: addTask,
        onToggle: toggleTask,
        onDelete: deleteTask,
      ),
      const SimplePage(
        title: 'الأهداف',
        icon: Icons.flag_outlined,
        description: 'هنا ستكون إدارة أهدافك.',
      ),
      const SimplePage(
        title: 'المال',
        icon: Icons.account_balance_wallet_outlined,
        description: 'الدخل والمصاريف والرصيد.',
      ),
      const SimplePage(
        title: 'ملاحظات',
        icon: Icons.notes_outlined,
        description: 'الملاحظات والأفكار.',
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.check_circle_outline),
              selectedIcon: Icon(Icons.check_circle),
              label: 'المهام',
            ),
            NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              selectedIcon: Icon(Icons.flag),
              label: 'الأهداف',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet),
              label: 'المال',
            ),
            NavigationDestination(
              icon: Icon(Icons.notes_outlined),
              selectedIcon: Icon(Icons.notes),
              label: 'ملاحظات',
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== DASHBOARD ====================

class DashboardPage extends StatelessWidget {
  final List<Task> tasks;
  final int completedTasks;
  final double progress;
  final List<Goal> goals;
  final Function(int) onToggle;

  const DashboardPage({
    super.key,
    required this.tasks,
    required this.completedTasks,
    required this.progress,
    required this.goals,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'صباح الخير 👋',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'حياتك، منظمة في مكان واحد',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 22),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'تقدم اليوم',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '$completedTasks / ${tasks.length}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tasks.isEmpty
                          ? 'ابدأ بإضافة أول مهمة لك'
                          : '${(progress * 100).round()}% من مهامك مكتملة',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'ملخصك',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.check_circle_outline,
                    title: 'المهام',
                    value: '${tasks.length}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    icon: Icons.done_all,
                    title: 'مكتملة',
                    value: '$completedTasks',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'مهام اليوم',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (tasks.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Center(
                    child: Text(
                      'لا توجد مهام اليوم',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
            else
              ...tasks.asMap().entries.map(
                (entry) {
                  final index = entry.key;
                  final task = entry.value;

                  return Card(
                    child: CheckboxListTile(
                      value: task.completed,
                      onChanged: (_) => onToggle(index),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ==================== TASKS ====================

class TasksPage extends StatelessWidget {
  final List<Task> tasks;
  final Function(String) onAdd;
  final Function(int) onToggle;
  final Function(int) onDelete;

  const TasksPage({
    super.key,
    required this.tasks,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  void showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة مهمة'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'اكتب المهمة...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                final title = controller.text.trim();

                if (title.isNotEmpty) {
                  onAdd(title);
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المهام',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'ما عندك حتى مهمة.\nاضغط + لإضافة مهمة جديدة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Card(
                  child: CheckboxListTile(
                    value: task.completed,
                    onChanged: (_) => onToggle(index),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    secondary: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => onDelete(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddTaskDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('مهمة'),
      ),
    );
  }
}

// ==================== STAT CARD ====================

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SIMPLE PAGE ====================

class SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const SimplePage({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 70,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
