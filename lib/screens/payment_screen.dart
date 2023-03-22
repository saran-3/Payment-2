import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late TextEditingController _amountController;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentFailureResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWalletResponse);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    _amountController.clear();
  }

  void handlerPaymentSuccessResponse(PaymentSuccessResponse response) {
    print('Success $response');
  }

  void handlerPaymentFailureResponse(PaymentFailureResponse response) {
    print('Failure $response');
  }

  void handlerExternalWalletResponse(ExternalWalletResponse response) {
    print('Wallet $response');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            'Do Payments Here',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _amountController,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Amount'),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Please Enter Amount";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();
                                var options = {
                                  'key': 'rzp_test_XfZU894TDFQWg5',
                                  'amount':
                                      num.parse(_amountController.text) * 100,
                                  'name': 'ShopNow.',
                                  'description': 'Groceries',
                                  'prefill': {
                                    'contact': '9894018373',
                                    'email': 'umsrn333@gmail.com'
                                  },
                                  'external': {
                                    'wallets': ['paytm']
                                  }
                                };
                                try {
                                  _razorpay.open(options);
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              child: const Text('Pay'))
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
