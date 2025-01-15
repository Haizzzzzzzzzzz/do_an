import 'package:flutter/material.dart';
import 'package:my_grocery/view/dashboard/dashboard_screen.dart';

class PaymentResultScreen extends StatelessWidget {
  final bool success;
  final String? transactionId;

  const PaymentResultScreen({
    super.key,
    required this.success,
    this.transactionId,
  });

  Future<bool> _onWillPop(BuildContext context) async {
    // Điều hướng đến DashboardScreen khi back
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
      (Route<dynamic> route) => false, // Xóa toàn bộ lịch sử điều hướng
    );
    return false; // Ngăn việc quay lại màn hình cũ
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context), // Lắng nghe nút Back
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            success ? 'Thanh toán thành công' : 'Thanh toán thất bại',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: success ? Colors.green : Colors.red,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Biểu tượng minh họa
                Icon(
                  success ? Icons.check_circle_outline : Icons.error_outline,
                  size: 100,
                  color: success ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 20),
                // Tiêu đề
                Text(
                  success ? 'Thanh toán thành công!' : 'Thanh toán thất bại!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: success ? Colors.green : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Mã giao dịch (nếu có)
                if (transactionId != null && success)
                  Column(
                    children: [
                      const Text(
                        'Mã giao dịch:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        transactionId!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                // Mô tả hoặc hành động
                Text(
                  success
                      ? 'Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi.'
                      : 'Vui lòng thử lại hoặc liên hệ hỗ trợ.',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Nút quay lại trang chính
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    backgroundColor: success ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Quay về trang chính',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
