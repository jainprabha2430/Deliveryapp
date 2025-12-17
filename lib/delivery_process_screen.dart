// lib/screens/delivery_upload_screen.dart

import 'package:flutter/material.dart';

import 'model/order_model.dart';

class DeliveryUploadScreen extends StatelessWidget {
  final OrderModel order;
  const DeliveryUploadScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Image Upload'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Order ID: ${order.orderId}\nCustomer: ${order.customerName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            // TODO: Implement image picker logic (Camera/Gallery)
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Image Upload Area (Tap to select/capture proof of delivery)'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement image upload and database update logic
                Navigator.pop(context);
              },
              icon: const Icon(Icons.upload),
              label: const Text('UPLOAD IMAGE AND COMPLETE DELIVERY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}