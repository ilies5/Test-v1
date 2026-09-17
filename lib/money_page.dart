	import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expense {
  String title;
  double amount;
  DateTime date;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
  });
}

class MoneyPage extends StatefulWidget {
  const MoneyPage({super.key});

  @override
  State<MoneyPage> createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  double monthlyIncome = 0;
  List<Expense> expenses = [];

  double get totalExpenses {
    return expenses.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  Future<void> saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();

    final savedExpenses = expenses.map((expense) {
      return '${expense.title}|${expense.amount}|${expense.date.toIso8601String()}';
    }).toList();

    await prefs.setStringList('expenses', savedExpenses);
  }

  @override
  void initState() {
    super.initState();
    loadIncome();
    loadExpenses();
  }

  Future<void> loadIncome() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      monthlyIncome = prefs.getDouble('monthly_income') ?? 0;
    });
  }

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final savedExpenses = prefs.getStringList('expenses') ?? [];

    final loadedExpenses = savedExpenses.map((item) {
      final parts = item.split('|');

      return Expense(
        title: parts[0],
        amount: double.tryParse(parts[1]) ?? 0,
        date: DateTime.tryParse(parts[2]) ?? DateTime.now(),
      );
    }).toList();

    setState(() {
      expenses = loadedExpenses;
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

  Future<void> addExpense() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة مصروف'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'اسم المصروف',
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'المبلغ',
                  suffixText: 'DA',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final amount = double.tryParse(amountController.text) ?? 0;

                if (title.isEmpty || amount <= 0) return;

                setState(() {
                  expenses.add(
                    Expense(
                      title: title,
                      amount: amount,
                      date: DateTime.now(),
                    ),
                  );
                });

                await saveExpenses();

                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المال'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addExpense,
        child: const Icon(Icons.add),
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
              trailing: Text(
                '${monthlyIncome.toStringAsFixed(0)} DA',
              ),
              onTap: editIncome,
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('المصاريف'),
              trailing: Text(
                '${totalExpenses.toStringAsFixed(0)} DA',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.savings_outlined),
              title: const Text('المتبقي'),
              trailing: Text(
                '${(monthlyIncome - totalExpenses).toStringAsFixed(0)} DA',
              ),
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

          if (expenses.isEmpty)
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

          ...expenses.map(
            (expense) => Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text(expense.title),
                subtitle: Text(
                  '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                ),
                trailing: Text(
                  '${expense.amount.toStringAsFixed(0)} DA',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
