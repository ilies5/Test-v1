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
    SimplePage(title: 'التقويم', icon: Icons.calendar_month),
    SimplePage(title: 'الأهداف', icon: Icons.flag),
    SimplePage(title: 'المال', icon: Icons.account_balance_wallet),
    SimplePage(title: 'الملاحظات', icon: Icons.notes),
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
              icon: Icon(Icons.calendar_month_outlined),
              label: 'التقويم',
            ),
            NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              label: 'الأهداف',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'المال',
            ),
            NavigationDestination(
              icon: Icon(Icons.notes_outlined),
              label: 'ملاحظات',
            ),
          ],
        ),
      ),
    );
  }
}

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
            const SizedBox(height: 4),
            const Text(
              'حياتك، منظمة في مكان واحد',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 22),

            // Today's progress
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 0,
                        minHeight: 9,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'ابدأ بإضافة مهامك لليوم',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick statistics
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
                  child: _StatCard(
                    icon: Icons.flag,
                    title: 'الأهداف',
                    value: '0',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    icon: Icons.task_alt,
                    title: 'المهام',
                    value: '0',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.account_balance_wallet,
                    title: 'المصروف',
                    value: '0 دج',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    icon: Icons.savings,
                    title: 'المتبقي',
                    value: '0 دج',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            const Text(
              'الوصول السريع',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _QuickAction(
              icon: Icons.add_task,
              title: 'إضافة مهمة',
              subtitle: 'أضف مهمة جديدة لليوم',
            ),

            _QuickAction(
              icon: Icons.flag_outlined,
              title: 'إضافة هدف',
              subtitle: 'حدد هدفًا تريد تحقيقه',
            ),

            _QuickAction(
              icon: Icons.receipt_long,
              title: 'إضافة مصروف',
              subtitle: 'سجل مصروفك اليومي',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 27,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_left),
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;

  const SimplePage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}