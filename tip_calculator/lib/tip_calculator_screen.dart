import 'package:flutter/material.dart';

class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final _billController = TextEditingController();
  double _tipPercent = 15;
  int _peopleCount = 1;

  double get _bill => double.tryParse(_billController.text) ?? 0;
  double get _totalTip => _bill * _tipPercent / 100;
  double get _totalPerPerson => (_bill + _totalTip) / _peopleCount;
  double get _tipPerPerson => _totalTip / _peopleCount;

  @override
  void initState() {
    super.initState();
    _billController.addListener(_onBillChanged);
  }

  void _onBillChanged() => setState(() {});

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }

  void _changePeople(int delta) {
    setState(() {
      _peopleCount = (_peopleCount + delta).clamp(1, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip Calculator'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      // ListView giúp cuộn khi bàn phím bật, tránh tràn màn hình
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1) Ô nhập tổng bill
          TextField(
            controller: _billController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Tổng bill',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          // 2) Slider chọn % tip
          Text('Tip: ${_tipPercent.round()}%',
              style: theme.textTheme.titleMedium),
          Slider(
            value: _tipPercent,
            min: 0,
            max: 30,
            divisions: 30, // kéo theo nấc 1%
            label: '${_tipPercent.round()}%',
            onChanged: (v) => setState(() => _tipPercent = v),
          ),
          const SizedBox(height: 16),

          // 3) Hàng chỉnh số người
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Số người', style: theme.textTheme.titleMedium),
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => _changePeople(-1),
                    icon: const Icon(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('$_peopleCount',
                        style: theme.textTheme.titleLarge),
                  ),
                  IconButton.filledTonal(
                    onPressed: () => _changePeople(1),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
            ),
          const SizedBox(height: 24),

          // 4) Card kết quả
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _resultRow('Tip per person', _tipPerPerson),
                  const Divider(),
                  _resultRow('Total per person', _totalPerPerson),
                  const Divider(),
                  _resultRow('Tổng tip', _totalTip),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dựng 1 dòng kết quả: nhãn bên trái, số tiền (2 chữ số thập phân) bên phải
  Widget _resultRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}