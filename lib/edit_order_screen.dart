// lib/screens/edit_order_screen.dart

import 'package:flutter/material.dart';
import 'model/order_model.dart';

class EditOrderScreen extends StatelessWidget {
  final OrderModel order;
  const EditOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Order Tracking Detail'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Editing Order ID: ${order.orderId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // TODO: Implement the full form UI here based on the screenshot (Editable fields)
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add Update logic using dbHelper.updateOrder(updatedOrder)
                // For demo, just navigate back
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check),
              label: const Text('UPDATE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('BACK'),
            ),
          ],
        ),
      ),
    );
  }
}