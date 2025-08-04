import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'order_placed_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final double total;

  const OrderDetailsScreen({super.key, required this.total});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _couponController = TextEditingController();
  final Dio dio = Dio();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String selectedPaymentMethod = 'Cash on Delivery';
  bool isPlacingOrder = false;

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await storage.read(key: 'auth_token');

    final data = {
      'deliveryAddress': _addressController.text.trim(),
      'phone': _phoneController.text.trim(),
      'paymentMethod': selectedPaymentMethod == 'Cash on Delivery' ? 'COD' : selectedPaymentMethod,
      if (_couponController.text.isNotEmpty) 'couponCode': _couponController.text.trim(),
    };

    setState(() => isPlacingOrder = true);

    try {
      final response = await dio.post(
        'http://192.168.100.66:5000/api/orders/place',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const OrderPlacedScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error placing order: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isPlacingOrder = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: const Color(0xFF0A1B2E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_addressController, 'Delivery Address'),
              const SizedBox(height: 12),
              _buildTextField(_phoneController, 'Phone Number', type: TextInputType.phone),
              const SizedBox(height: 12),
              _buildTextField(_couponController, 'Coupon Code (optional)', required: false),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedPaymentMethod,
                dropdownColor: const Color(0xFF1A2B3E),
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF1A2B3E),
                  border: OutlineInputBorder(),
                ),
                items: ['Cash on Delivery']
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => selectedPaymentMethod = value);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
                onPressed: isPlacingOrder ? null : _placeOrder,
                child: isPlacingOrder
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Check Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType type = TextInputType.text, bool required = true}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF1A2B3E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: required
          ? (value) => value == null || value.isEmpty ? 'Required' : null
          : null,
    );
  }
}
