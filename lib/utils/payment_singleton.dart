class PaymentSignleton {
  static final PaymentSignleton _instance = PaymentSignleton._internal();

  factory PaymentSignleton() {
    return _instance;
  }

  PaymentSignleton._internal();

  bool _isPayment = false;

  bool get isPayment => _isPayment;

  set paymentMethod(bool value) {
    _isPayment = value;
  }
}