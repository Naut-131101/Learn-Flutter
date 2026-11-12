import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  // Lấy màu chữ dựa trên giá trị của _count
  Color get _countColor {
    if (_count > 0) return Colors.blue;
    if (_count < 0) return Colors.red;
    return Colors.black;
  }

  // Tăng giá trị (tối đa 100)
  void _increment() {
    if (_count >= 100) return;
    setState(() => _count++);
  }

  // Giảm giá trị (tối thiểu -100)
  void _decrement() {
    if (_count <= -100) return;
    setState(() => _count--);
  }

  // Đặt lại về 0
  void _reset() => setState(() => _count = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini lab: Counter app'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị thông báo Max/Min nếu chạm giới hạn (Phần mở rộng)
            if (_count == 100)
              const Text(
                'Max',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
              )
            else if (_count == -100)
              const Text(
                'Min',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
              )
            else
              const SizedBox(height: 27), // Giữ khoảng cách UI không bị nhảy

            const SizedBox(height: 10),

            // Số đếm font 64, bold, đổi màu theo giá trị
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '$_count',
                key: ValueKey<int>(_count),
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: _countColor,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Hàng chứa 3 button: Giảm (-), Reset (0), Tăng (+)[cite: 1]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút Giảm (-)
                ElevatedButton(
                  onPressed: _count <= -100 ? null : _decrement, // Disable khi chạm limit -100[cite: 1]
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Giam', style: TextStyle(fontSize: 24)),
                ),

                const SizedBox(width: 16),

                // Nút Reset (0)
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Resset', style: TextStyle(fontSize: 20)),
                ),

                const SizedBox(width: 16),

                // Nút Tăng (+) dạng FloatingActionButton theo yêu cầu
                ElevatedButton(
                  onPressed: _count >= 100 ? null : _increment, // Disable khi chạm limit 100
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Tang', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}