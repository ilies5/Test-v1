import 'package:flutter/material.dart';

class Goal {
  String title;
  int progress;

  Goal({
    required this.title,
    this.progress = 0,
  });
}

class GoalsPage extends StatelessWidget {
  final List<Goal> goals;
  final Future<void> Function(String) onAdd;
  final Future<void> Function(int, int) onUpdate;
  final Future<void> Function(int) onDelete;

  const GoalsPage({
    super.key,
    required this.goals,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  void _showAddGoalDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة هدف'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'اكتب هدفك...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
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
        title: const Text('الأهداف'),
      ),
      body: goals.isEmpty
          ? const Center(
              child: Text(
                'ما عندك حتى هدف حاليا.\nأضف أول هدف ليك',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                goal.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => onDelete(index),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: goal.progress / 100,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: goal.progress.toDouble(),
                                min: 0,
                                max: 100,
                                divisions: 100,
                                label: '${goal.progress}%',
                                onChanged: (value) {
                                  onUpdate(index, value.round());
                                },
                              ),
                            ),
                            Text('${goal.progress}%'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
