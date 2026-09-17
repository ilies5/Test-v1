import 'package:flutter/material.dart';

class MoneyPage extends StatelessWidget {
  const MoneyPage({super.key});

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
