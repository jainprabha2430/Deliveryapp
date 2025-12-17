import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/order_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'delivery_tracking.db');
    // **IMPORTANT:** If the table schema changes, you must increment the version number
    // or uninstall the app to clear the old database.
    return await openDatabase(
      path,
      version: 2, // Version increased to 2 to force schema update
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Handle database upgrades (important if the app is already installed)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns if upgrading from version 1
      await db.execute('ALTER TABLE orders ADD COLUMN sellerGSTIN TEXT');
      await db.execute('ALTER TABLE orders ADD COLUMN challanNo TEXT');
      await db.execute('ALTER TABLE orders ADD COLUMN buyerAddressDetails TEXT');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE orders(
        orderId TEXT PRIMARY KEY,
        marketplace TEXT,
        sellerName TEXT,
        trackingStatus TEXT,
        orderDate TEXT,
        expectedDispatchDate TEXT,
        actualDeliveryDate TEXT,
        customerName TEXT,
        buyerContactNo TEXT,
        deliveryImageFilePath TEXT,
        sellerGSTIN TEXT,          -- CORRECTED: NEW FIELD
        challanNo TEXT,            -- CORRECTED: NEW FIELD
        buyerAddressDetails TEXT   -- CORRECTED: NEW FIELD
      )
      '''
    );
    // Insert Demo Data
    await _insertDemoData(db);
    // Insert a few more orders for filtering demonstration
    await _insertAdditionalDemoData(db);
  }

  Future<void> _insertDemoData(Database db) async {
    // Demo data now includes Challan/GSTIN/Address details
    final demoOrder = OrderModel(
      orderId: '407-3110449-8288310',
      marketplace: 'AMAZON',
      sellerName: 'JS HOME DECOR',
      trackingStatus: 'Out For Delivery',
      orderDate: '13-Nov-2025',
      expectedDispatchDate: '14-Nov-2025',
      actualDeliveryDate: '24-Nov-2025',
      customerName: 'Ruchika Achera',
      buyerContactNo: '9511525927',
      sellerGSTIN: '08AHAPJ7860N1ZV',
      challanNo: 'CHAZ2511140000055613',
      buyerAddressDetails: 'jaipur global sevices\nvki road no.1 jaipur\nState: RAJASTHAN\nCity:JAIPUR\nPincode: 302013',
    );
    await db.insert('orders', demoOrder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> _insertAdditionalDemoData(Database db) async {
    final order1 = OrderModel(
      orderId: '407-5555555',
      marketplace: 'FLIPKART',
      sellerName: 'ABC TRADERS',
      trackingStatus: 'Delivered',
      orderDate: '01-Dec-2025',
      expectedDispatchDate: '02-Dec-2025',
      actualDeliveryDate: '05-Dec-2025',
      customerName: 'Vivek Sharma',
      buyerContactNo: '9876543210',
      sellerGSTIN: '12ABCDE1234F1Z1',
      challanNo: 'FLIP2200000001',
      buyerAddressDetails: '101, MG Road\nBangalore\nState: KARNATAKA\nCity: BENGALURU\nPincode: 560001',
    );
    final order2 = OrderModel(
      orderId: '100-1234567',
      marketplace: 'AMAZON',
      sellerName: 'JS HOME DECOR',
      trackingStatus: 'Out For Delivery',
      orderDate: '10-Dec-2025',
      expectedDispatchDate: '11-Dec-2025',
      actualDeliveryDate: '',
      customerName: 'Priya Singh',
      buyerContactNo: '9998887776',
      sellerGSTIN: '08AHAPJ7860N1ZV',
      challanNo: 'CHAZ2511140000055614',
      buyerAddressDetails: '15, Model Town\nJaipur\nState: RAJASTHAN\nCity: JAIPUR\nPincode: 302001',
    );
    await db.insert('orders', order1.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await db.insert('orders', order2.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }


  // Fetch all orders
  Future<List<OrderModel>> getOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('orders');
    return List.generate(maps.length, (i) {
      return OrderModel.fromMap(maps[i]);
    });
  }

  // Update an existing order
  Future<void> updateOrder(OrderModel order) async {
    final db = await database;
    await db.update(
      'orders',
      order.toMap(),
      where: 'orderId = ?',
      whereArgs: [order.orderId],
    );
  }
}