import 'package:flutter/material.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final pages = const [
    DashboardPage(),
    TasksPage(),
    GoalsPage(),
    MoneyPage(),
    NotesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() => currentIndex = index);
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
  const DashboardPage({super.key});

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

            // Progress
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
                          '0 / 5',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const LinearProgressIndicator(
                      value: 0,
                      minHeight: 9,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'لم تنجز أي مهمة بعد',
                      style: TextStyle(color: Colors.grey),
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
              children: const [
                Expanded(
                  child: StatCard(
                    icon: Icons.check_circle_outline,
                    title: 'المهام',
                    value: '0',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    icon: Icons.flag_outlined,
                    title: 'الأهداف',
                    value: '0',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    icon: Icons.attach_money,
                    title: 'المصاريف',
                    value: '0 دج',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    icon: Icons.account_balance,
                    title: 'الرصيد',
                    value: '0 دج',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            const Text(
              'مهام اليوم',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.check_box_outline_blank),
                title: const Text('أضف أول مهمة لك'),
                subtitle: const Text('نظم يومك وابدأ بخطوة صغيرة'),
                trailing: Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'الوصول السريع',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_task),
                    title: const Text('إضافة مهمة'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text('إضافة هدف'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('إضافة مصروف'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
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
              style: const TextStyle(color: Colors.grey),
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

// ==================== TASKS ====================

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'المهام',
      icon: Icons.check_circle_outline,
      description: 'هنا ستكون إدارة المهام اليومية والأسبوعية.',
    );
  }
}

// ==================== GOALS ====================

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'الأهداف',
      icon: Icons.flag_outlined,
      description: 'هنا ستتمكن من إنشاء أهدافك ومتابعة تقدمك.',
    );
  }
}

// ==================== MONEY ====================

class MoneyPage extends StatelessWidget {
  const MoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'المال',
      icon: Icons.account_balance_wallet_outlined,
      description: 'الدخل والمصاريف والرصيد الشهري.',
    );
  }
}

// ==================== NOTES ====================

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'الملاحظات',
      icon: Icons.notes_outlined,
      description: 'مكان خاص للملاحظات والأفكار.',
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

