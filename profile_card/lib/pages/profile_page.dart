import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo.shade200, Colors.purple.shade100],
          ),
        ),
        child: Center(
          child: Card(
            elevation: 12,
            shadowColor: Colors.black26,
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Avatar có hiệu ứng Shadow & Viền Gradient ---
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade400, Colors.purple.shade300],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 42,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Tên & Nghề nghiệp ---
                  const Text(
                    '黃 業 俊',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Huynh Nghiep Tuan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Flutter Developer',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Thống kê (Followers / Following / Projects) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Followers', '1.2k'),
                      _buildDivider(),
                      _buildStatItem('Following', '350'),
                      _buildDivider(),
                      _buildStatItem('Projects', '12'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- Icon Mạng xã hội bo tròn ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIconButton(Icons.facebook, Colors.blue.shade800),
                      const SizedBox(width: 12),
                      _buildSocialIconButton(Icons.language, Colors.teal),
                      const SizedBox(width: 12),
                      _buildSocialIconButton(Icons.camera_alt, Colors.pink.shade400),
                      const SizedBox(width: 12),
                      _buildSocialIconButton(Icons.work, Colors.blue.shade600),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Nút Follow phong cách Gradient ---
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: Colors.indigo.withValues(alpha: 0.4),
                      ),
                      onPressed: () {},
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.indigo.shade600, Colors.purple.shade500],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Follow',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget phụ: Nút Icon mạng xã hội
  static Widget _buildSocialIconButton(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  // Widget phụ: Mục thống kê
  static Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  // Widget phụ: Vạch phân cách
  static Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}