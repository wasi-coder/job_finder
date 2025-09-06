import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  // For Bangladesh market, you can integrate with:
  // - SSLCommerz (most popular)
  // - bKash
  // - Nagad
  // - Stripe

  static const String _sslCommerzStoreId = 'your_store_id';
  static const String _sslCommerzStorePassword = 'your_store_password';
  static const bool _isSandbox = true; // Set to false for production

  static String get sslCommerzBaseUrl {
    return _isSandbox
        ? 'https://sandbox.sslcommerz.com'
        : 'https://securepay.sslcommerz.com';
  }

  static Future<Map<String, dynamic>> initiatePayment({
    required String jobId,
    required String jobTitle,
    required double amount,
    required String applicantId,
    required String applicantName,
    required String applicantEmail,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$sslCommerzBaseUrl/gwprocess/v4/api.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'store_id': _sslCommerzStoreId,
          'store_passwd': _sslCommerzStorePassword,
          'total_amount': amount.toString(),
          'currency': 'BDT',
          'tran_id': 'JOB_${jobId}_${applicantId}_${DateTime.now().millisecondsSinceEpoch}',
          'success_url': 'your_success_url',
          'fail_url': 'your_fail_url',
          'cancel_url': 'your_cancel_url',
          'cus_name': applicantName,
          'cus_email': applicantEmail,
          'cus_phone': 'customer_phone',
          'product_name': 'Job Application Fee - $jobTitle',
          'product_category': 'Service',
          'product_profile': 'general',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'payment_url': data['GatewayPageURL'],
          'transaction_id': data['tran_id'],
        };
      } else {
        return {
          'success': false,
          'error': 'Payment initiation failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> verifyPayment(String transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('$sslCommerzBaseUrl/validator/api/validationserverAPI.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'store_id': _sslCommerzStoreId,
          'store_passwd': _sslCommerzStorePassword,
          'tran_id': transactionId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'status': data['status'],
          'amount': data['amount'],
          'currency': data['currency'],
        };
      } else {
        return {
          'success': false,
          'error': 'Payment verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Commission calculation (5-10% of job amount)
  static double calculateCommission(double jobAmount) {
    return jobAmount * 0.08; // 8% commission
  }

  // For demo purposes - simulate payment
  static Future<Map<String, dynamic>> simulatePayment({
    required double amount,
    required String jobTitle,
  }) async {
    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate 90% success rate
    final isSuccess = DateTime.now().millisecond % 10 != 0;

    if (isSuccess) {
      return {
        'success': true,
        'transaction_id': 'DEMO_${DateTime.now().millisecondsSinceEpoch}',
        'amount': amount,
        'message': 'Payment processed successfully',
      };
    } else {
      return {
        'success': false,
        'error': 'Payment failed - please try again',
      };
    }
  }
}