import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyPage extends StatefulWidget {
  const MoneyPage({super.key});

  @override
  State<MoneyPage> createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  double monthlyIncome = 0;

  @override
  void initState() {
    super.initState();
    loadIncome();
  }

  Future<void> loadIncome() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      monthlyIncome = prefs.getDouble('monthly_income') ?? 0;
    });
  }

  Future<void> editIncome() async {
    final controller = TextEditingController(
      text: monthlyIncome.toStringAsFixed(0),
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('الدخل الشهري'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              hintText: 'مثال: 50000',
              suffixText: 'DA',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final value = double.tryParse(controller.text) ?? 0;

                if (value < 0) return;

                final prefs = await SharedPreferences.getInstance();
                await prefs.setDouble('monthly_income', value);

                if (!mounted) return;

                setState(() {
                  monthlyIncome = value;
                });

                  if (!context.mounted) return;
                  Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المال'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'ملخصك المالي',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('الدخل الشهري'),
              trailing: const Text('0 DA'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('المصاريف'),
              trailing: const Text('0 DA'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.savings_outlined),
              title: const Text('المتبقي'),
              trailing: const Text('0 DA'),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'المصاريف اليومية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Center(
                child: Text(
                  'لا توجد مصاريف مسجلة',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
