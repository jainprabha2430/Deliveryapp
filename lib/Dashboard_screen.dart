import 'package:flutter/material.dart';
import 'challan_screen.dart';
import 'database_helpher/database_db.dart';
import 'delivery_process_screen.dart';
import 'edit_order_screen.dart';
import 'model/order_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  List<OrderModel> _allOrders = [];
  List<OrderModel> _filteredOrders = [];
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _sellerNameController = TextEditingController();
  String? _selectedMarketplace = 'All';
  String? _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }
  @override
  void dispose() {
    _orderIdController.dispose();
    _sellerNameController.dispose();
    super.dispose();
  }
  void _loadOrders() async {
    setState(() {
      _allOrders = [];
      _filteredOrders = [];
    });

    final orders = await dbHelper.getOrders();
    setState(() {
      _allOrders = orders;
      _filteredOrders = orders;
      if (_selectedMarketplace == null) _selectedMarketplace = 'All';
      if (_selectedStatus == null) _selectedStatus = 'All';
    });
  }

  void _refreshOrders() {
    _loadOrders();
    _applyFilters();
  }
  void _applyFilters() {
    final searchOrderId = _orderIdController.text.toLowerCase();
    final searchSellerName = _sellerNameController.text.toLowerCase();
    setState(() {
      _filteredOrders = _allOrders.where((order) {
        bool matches = true;
        if (searchOrderId.isNotEmpty && !order.orderId.toLowerCase().contains(searchOrderId)) {
          matches = false;
        }
        if (matches && searchSellerName.isNotEmpty && !order.sellerName.toLowerCase().contains(searchSellerName)) {
          matches = false;
        }
        if (matches && _selectedMarketplace != 'All' && order.marketplace != _selectedMarketplace) {
          matches = false;
        }
        if (matches && _selectedStatus != 'All' && order.trackingStatus != _selectedStatus) {
          matches = false;
        }

        return matches;
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_filteredOrders.length} orders found.')),
    );
  }
  void _resetFilters() {
    setState(() {
      _orderIdController.clear();
      _sellerNameController.clear();
      _selectedMarketplace = 'All';
      _selectedStatus = 'All';
    });
    _loadOrders();
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Out For Delivery':
        return Colors.orange.shade800;
      case 'Delivered':
        return Colors.green.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  void _navigateToEditScreen(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOrderScreen(order: order),
      ),
    ).then((_) => _refreshOrders());
  }

  void _navigateToDeliveryScreen(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryUploadScreen(order: order),
      ),
    ).then((_) => _refreshOrders());
  }

  void _navigateToChallanPrint(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallanPrintScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Delivery Tracker'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOrders,
            tooltip: 'Refresh Orders',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterForm(),
          const Divider(height: 1),
          Expanded(
            child: _buildOrderList(),
          ),
        ],
      ),
    );
  }
  Widget _buildFilterForm() {
    const List<String> marketplaceOptions = ['All', 'AMAZON', 'FLIPKART', 'MYNTRA'];
    const List<String> statusOptions = ['All', 'Out For Delivery', 'Delivered', 'Cancelled'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Search Parameters', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _orderIdController,
            decoration: const InputDecoration(
              labelText: 'Order ID',
              prefixIcon: Icon(Icons.receipt),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _sellerNameController,
            decoration: const InputDecoration(
              labelText: 'Seller Name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Marketplace',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  value: _selectedMarketplace,
                  items: marketplaceOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMarketplace = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  value: _selectedStatus,
                  items: statusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: _applyFilters,
                icon: const Icon(Icons.search, size: 18),
                label: const Text('SEARCH'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _resetFilters,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('RESET'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildOrderList() {
    if (_allOrders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (_filteredOrders.isEmpty) {
      return const Center(child: Text('No orders found matching the filter criteria.'));
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _filteredOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredOrders[index];
          return _buildOrderCard(order);
        },
      );
    }
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Order ID: ${order.orderId}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.trackingStatus),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.trackingStatus,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 18),
            _buildInfoRow('Marketplace', order.marketplace),
            _buildInfoRow('Seller', order.sellerName),
            _buildInfoRow('Order Date', order.orderDate),
            _buildInfoRow('Dispatch Date', order.expectedDispatchDate),
            _buildInfoRow('Delivery Date', order.actualDeliveryDate.isEmpty ? 'N/A' : order.actualDeliveryDate),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Edit Order',
                  onPressed: () => _navigateToEditScreen(order),
                ),
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.grey),
                  tooltip: 'History',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order History feature under development.')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.local_shipping, color: Colors.green),
                  tooltip: 'Delivery Process',
                  onPressed: () => _navigateToDeliveryScreen(order),
                ),
                IconButton(
                  icon: const Icon(Icons.print, color: Colors.black),
                  tooltip: 'Challan Print',
                  onPressed: () => _navigateToChallanPrint(order),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}