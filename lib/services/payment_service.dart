class PaymentService {
  Future<bool> processPayment({
    required int amount,
    required String paymentMethod,
    required String orderId,
  }) async {
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));
    
    // Mock payment - in real app, this would integrate with payment gateway
    return true;
  }

  Future<String> generatePaymentUrl({
    required int amount,
    required String orderId,
    required String customerEmail,
  }) async {
    // Simulate URL generation
    await Future.delayed(const Duration(seconds: 2));
    return 'https://payment-gateway.com/pay?amount=$amount&order=$orderId';
  }
}