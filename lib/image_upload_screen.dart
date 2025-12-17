import 'package:flutter/material.dart';

class ImageUploadDownloadScreen extends StatelessWidget {
  const ImageUploadDownloadScreen({super.key});

  final Color primaryOrange = const Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryOrange,
        title: const Text(
          'Self Delivered Image Upload And Download',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Process Detail',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryOrange),
              ),
              const Divider(height: 30),

              // --- Row 1: Ticket ID, Marketplace, Seller Name, Order ID ---
              Row(
                children: [
                  Expanded(child: _buildTextFormField('Ticket ID', initialValue: '55613', readOnly: true)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextFormField('Online Marketplaces', initialValue: 'AMAZON', readOnly: true)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextFormField('Seller Name', initialValue: 'JS HOME DECOR', readOnly: true)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextFormField('Order ID', initialValue: '407-3110449', readOnly: true)),
                ],
              ),
              const SizedBox(height: 15),

              // --- Row 2: Customer Name, Customer No, Tracking Status, File Upload ---
              Row(
                children: [
                  Expanded(child: _buildTextFormField('Customer Name')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextFormField('Customer No')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildDropdown('Tracking Status', ['Delivered', 'Failed'], 'Delivered')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildFileUploadField('File Upload')), // Custom File Upload Field
                ],
              ),
              const SizedBox(height: 30),

              // --- Upload Button ---
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () { /* Final Upload Logic */ },
                  icon: const Icon(Icons.cloud_upload, color: Colors.white),
                  label: const Text('UPLOAD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  ),
                ),
              ),

              const Divider(height: 50),

              // --- Download/Records Section ---
              Text(
                'Uploaded Records (10 records per page)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
              ),
              // Note: Here you would add a small DataTable showing uploaded images/proofs with a Download action button

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Text Form Field
  Widget _buildTextFormField(String label, {bool readOnly = false, String? initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }

  // Helper widget for Dropdown Form Field
  Widget _buildDropdown(String label, List<String> items, String initialValue) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      value: initialValue,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // Handle selection
      },
    );
  }

  // Custom File Upload Field (Simulating the Choose File button)
  Widget _buildFileUploadField(String label) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'No file chosen',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // File picker logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              padding: EdgeInsets.zero,
              minimumSize: const Size(80, 35),
            ),
            child: const Text('Choose File', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
// --- END Image Upload/Download Screen ---