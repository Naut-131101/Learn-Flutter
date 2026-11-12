import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // state + validators + _submit + build() thêm ở các bước sau
  // Key để truy cập trạng thái Form và gọi validate()
  final _formKey = GlobalKey<FormState>();

  // Mỗi field text cần 1 controller riêng
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // State cho các field không phải text
  String _gender = 'male'; // giá trị radio đang chọn
  DateTime? _dob; // ngày sinh, null = chưa chọn
  bool _agreeTerms = false; // tick điều khoản
  bool _isLoading = false; // đang submit hay không
  bool _obscurePassword = true; // ẩn/hiện mật khẩu
  bool _obscureConfirm = true; // ẩn/hiện xác nhận mật khẩu

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Vui lòng nhập họ tên';
    if (v.length < 2) return 'Họ tên phải từ 2 ký tự trở lên';
    return null;
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Vui lòng nhập email';
    // Regex email cơ bản: phần_tên@tên_miền.đuôi
    final emailRegex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
    if (!emailRegex.hasMatch(v)) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
      return 'Số điện thoại phải đúng 10 chữ số';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (v.length < 6) return 'Mật khẩu phải từ 6 ký tự trở lên';
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(v);
    final hasDigit = RegExp(r'[0-9]').hasMatch(v);
    if (!hasLetter || !hasDigit) return 'Mật khẩu phải có cả chữ và số';
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập lại mật khẩu';
    // So sánh với controller mật khẩu, KHÔNG so với chính value của field này
    if (value != _passwordController.text) {
      return 'Mật khẩu nhập lại không khớp';
    }
    return null;
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(), // không cho chọn ngày tương lai
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    // 1) Chạy validator của mọi TextFormField
    if (!_formKey.currentState!.validate()) return;

    // 2) Kiểm tra riêng các field không nằm trong validator
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn phải đồng ý điều khoản')),
      );
      return;
    }
    if (_dob == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày sinh')));
      return;
    }

    // 3) Giả lập gọi API
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return; // tránh dùng context sau khi widget đã bị hủy
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Đăng ký thành công 🎉')));
  }

  @override
  Widget build(BuildContext context) {
    final dobText = _dob == null
        ? 'Chọn ngày sinh'
        : '${_dob!.day}/${_dob!.month}/${_dob!.year}';

    return Scaffold(
      backgroundColor: const Color(0xFF10182B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10182B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Create Account',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF182746), Color(0xFF10182B), Color(0xFF0C1220)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 48,
                        color: Color(0xFF536DFE),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Create Your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF17213A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Điền thông tin bên dưới để tạo tài khoản mới.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8992A5),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Họ tên
                      const Text(
                        'Họ và tên',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        validator: _validateName,
                        decoration: InputDecoration(
                          hintText: 'Nhập họ và tên',
                          prefixIcon: const Icon(Icons.person_outline),
                          filled: true,
                          fillColor: const Color(0xFFF6F7FB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Email
                      const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        decoration: InputDecoration(
                          hintText: 'example@email.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: const Color(0xFFF6F7FB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Số điện thoại
                      const Text(
                        'Số điện thoại',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                        decoration: InputDecoration(
                          hintText: 'Nhập số điện thoại',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          filled: true,
                          fillColor: const Color(0xFFF6F7FB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Mật khẩu
                      const Text(
                        'Mật khẩu',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: _validatePassword,
                        decoration: InputDecoration(
                          hintText: 'Nhập mật khẩu',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF6F7FB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Xác nhận mật khẩu
                      const Text(
                        'Xác nhận mật khẩu',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmController,
                        obscureText: _obscureConfirm,
                        validator: _validateConfirm,
                        decoration: InputDecoration(
                          hintText: 'Nhập lại mật khẩu',
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF6F7FB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Giới tính
                      const Text(
                        'Giới tính',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      RadioGroup<String>(
                        groupValue: _gender,
                        onChanged: (v) =>
                            setState(() => _gender = v ?? _gender),
                        child: const Column(
                          children: [
                            RadioListTile<String>(
                              title: Text('Nam'),
                              value: 'male',
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                            RadioListTile<String>(
                              title: Text('Nữ'),
                              value: 'female',
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                            RadioListTile<String>(
                              title: Text('Khác'),
                              value: 'other',
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Ngày sinh
                      const Text(
                        'Ngày sinh',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _pickDob,
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: Text(
                          _dob == null
                              ? 'Chọn ngày sinh'
                              : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: const Color(0xFF536DFE),
                          side: const BorderSide(color: Color(0xFFEAECF2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Điều khoản
                      CheckboxListTile(
                        value: _agreeTerms,
                        onChanged: (v) =>
                            setState(() => _agreeTerms = v ?? false),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: const Color(0xFF536DFE),
                        title: const Text(
                          'Tôi đồng ý với điều khoản sử dụng',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit
                      SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF536DFE),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Tạo tài khoản',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
