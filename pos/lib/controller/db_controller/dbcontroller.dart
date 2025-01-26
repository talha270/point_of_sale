import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class Dbcontroller with ChangeNotifier {
  // Table names and columns
  final String inventorytablename = "inventory_table";
  final String inventorycolumn1sno = "s_no";
  final String inventorycolumn2name = "name";
  final String inventorycolumn3price = "price";
  final String inventorycolumn4description = "description";
  final String inventorycolumn5nounit = "units";
  final String inventorycolumn6cost = "cost";
  final String inventorycolumn7image = "image";
  final String inventorycolumn8taxrate = "taxrate";
  final String inventorycolumn9categoriesname = "categories";
  final String inventorycolumn10barcode = "barcode";

  final String salestablename = "sales_table";
  final String salescolumn1saleid = "saleid";
  final String salescolumn2customername = "cumtomername";
  final String salescolumn3date = "date";
  final String salescolumn4time = "time";
  final String salescolumn5totalamount = "totalamount";
  final String salescolumn6totalcost = "totalcost";
  final String salescolumn7monthyear = "monthyear";
  final String salescolumn8year = "year";

  final String salesitemtablename = "sale_items";
  final String salesitemcolumn1id = "id";
  final String salesitemcolumn2salesid = "saleid";
  final String salesitemcolumn3productName = "productName";
  final String salesitemcolumn4quantity = "quantity";
  final String salesitemcolumn5price = "price";
  final String salesitemcolumn6total = "total";
  final String salesitemcolumn7date = "date";
  final String salesitemcolumn8monthyear = "monthyear";
  final String salesitemcolumn9year = "year";
  // Database variable
  Database? mydb;

  // This function returns the database instance
  Future<Database> getdatabase() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop (Windows, Linux, macOS)
      sqfliteFfiInit(); // Initialize FFI for desktop
      databaseFactory = databaseFactoryFfi; // Use FFI factory for desktop
    }

    mydb = mydb ?? await openorcreatedb();
    return mydb!;
  }

  // Function to open or create the database
  Future<Database> openorcreatedb() async {
    Directory appdir = await getApplicationDocumentsDirectory();
    String dbpath = join(appdir.path, "inventorytechdb.db");
    return await openDatabase(dbpath, version: 1, onCreate: (db, version) {
    db.execute('''
          CREATE TABLE $inventorytablename (
            $inventorycolumn1sno INTEGER PRIMARY KEY AUTOINCREMENT,
            $inventorycolumn2name TEXT,
            $inventorycolumn3price REAL,
            $inventorycolumn4description TEXT,
            $inventorycolumn5nounit INTEGER,
            $inventorycolumn6cost REAL,
            $inventorycolumn7image  TEXT,
            $inventorycolumn8taxrate REAL,
            $inventorycolumn9categoriesname TEXT,
            $inventorycolumn10barcode TEXT
          )
        ''');
      db.execute('''
          CREATE TABLE $salestablename (
            $salescolumn1saleid INTEGER PRIMARY KEY AUTOINCREMENT,
            $salescolumn2customername TEXT,
            $salescolumn3date TEXT,
            $salescolumn4time TEXT,
            $salescolumn5totalamount REAL,
            $salescolumn6totalcost REAL,
            $salescolumn7monthyear TEXT,
            $salescolumn8year TEXT
          )
        ''');
    db.execute('''
         CREATE TABLE $salesitemtablename (
          $salesitemcolumn1id INTEGER PRIMARY KEY AUTOINCREMENT,  
          $salesitemcolumn2salesid INTEGER,                        
          $salesitemcolumn3productName TEXT,                      
          $salesitemcolumn4quantity INTEGER,                      
          $salesitemcolumn5price REAL,                            
          $salesitemcolumn6total REAL,                            
          $salesitemcolumn7date TEXT,                            
          $salesitemcolumn8monthyear TEXT,                            
          $salesitemcolumn9year TEXT,                            
          FOREIGN KEY (saleId) REFERENCES sales (saleId)
)
        ''');

    });
  }

  // Insertion queries
  Future<bool> adddatainventory({required String barcodestring,required String image,required String productname, required double perunitprice, required double perunitcost, required String description, required int noofunit,required double taxrate,required String categorie}) async {
    var db = await getdatabase();
    int effectedrow = await db.insert(inventorytablename, {
      inventorycolumn2name: productname,
      inventorycolumn3price: perunitprice,
      inventorycolumn4description: description,
      inventorycolumn5nounit: noofunit,
      inventorycolumn6cost: perunitcost,
      inventorycolumn7image: image,
      inventorycolumn8taxrate :taxrate,
      inventorycolumn9categoriesname:categorie,
      inventorycolumn10barcode:barcodestring
    });
    return effectedrow > 0;
  }

  Future<int> insertSale({required double totalcost,required String monthyear,required String year,required String name,required String date,required String time,required double total}) async {
    var db = await getdatabase();
    Map<String, dynamic> saleRow = {
      salescolumn2customername: name,
      salescolumn3date: date,
      salescolumn4time: time,
      salescolumn5totalamount: total,
      salescolumn6totalcost:totalcost,
      salescolumn7monthyear:monthyear,
      salescolumn8year:year
    };
    return await db.insert(salestablename, saleRow);
  }

  Future<int> insertSaleItem({required String monthyear,required String year,required String date,required int saleId,required String productName,required int quantity,required double price,required double total}) async {
    var db = await getdatabase();
    Map<String, dynamic> saleItemRow = {
    salesitemcolumn2salesid: saleId,
    salesitemcolumn3productName: productName,
    salesitemcolumn4quantity: quantity,
    salesitemcolumn5price: price,
    salesitemcolumn6total: total,
    salesitemcolumn7date: date,
    salesitemcolumn8monthyear:monthyear,
    salesitemcolumn9year:year
  };
    return await db.insert('sale_items', saleItemRow);
  }

  Future<List<Map<String, dynamic>>> getUniqueProductSales({required String date,required String wherecolumn}) async {
    var db = await getdatabase();

    return await db.rawQuery('''
    SELECT $salesitemcolumn3productName, SUM($salesitemcolumn4quantity) AS $salesitemcolumn4quantity
    FROM $salesitemtablename
    WHERE $wherecolumn = ?
    GROUP BY $salesitemcolumn3productName
    ORDER BY  SUM($salesitemcolumn4quantity) DESC
  ''', [date]);
  }


  Future<List<Map<String, dynamic>>> gettodayprofitandcost() async {
    var db = await getdatabase();
    // Get today's date in 'YYYY-MM-DD' format
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    return await db.rawQuery('''
    SELECT SUM($salescolumn6totalcost) AS $salescolumn6totalcost, SUM($salescolumn5totalamount) AS $salescolumn5totalamount
    FROM $salestablename
    WHERE $salescolumn3date = ?
  ''', [today]);
  }

  Future<List<Map<String, dynamic>>> getprofitandcost({required String date,required String wherecolumn}) async {
    var db = await getdatabase();
    return await db.rawQuery('''
    SELECT SUM($salescolumn6totalcost) AS $salescolumn6totalcost, SUM($salescolumn5totalamount) AS $salescolumn5totalamount
    FROM $salestablename
    WHERE $wherecolumn = ?
  ''', [date]);
  }
  // Query data

  Future<List<Map<String, dynamic>>> getdbdata({required String tablename}) async {
    var db = await getdatabase();

    List<Map<String, dynamic>> temp = await db.query(tablename,);
    return temp;
  }
  Future<List<Map<String,dynamic>>>  getcategories()async{
    var db = await getdatabase();
    List<Map<String, dynamic>> result = await db.rawQuery('''
  SELECT DISTINCT $inventorycolumn9categoriesname 
  FROM $inventorytablename
  ''');
    return result;
  }
  Future<List<Map<String,dynamic>>>  getsalesdate()async{
    var db = await getdatabase();
    List<Map<String, dynamic>> result = await db.rawQuery('''
  SELECT DISTINCT $salescolumn3date 
  FROM $salestablename
  ''');
    return result;
  }
  Future<List<Map<String,dynamic>>> getsalesitem({required int salesid}) async {
    var db = await getdatabase();
    List<Map<String,dynamic>> temp= await db.query(
      salesitemtablename,
      where: '$salesitemcolumn2salesid = ?',whereArgs: [salesid]
    );
    return temp;
  }
  Future<List>  getproductnames()async{
    var db = await getdatabase();
    List<Map<String, dynamic>> result = await db.rawQuery('''
  SELECT $inventorycolumn2name 
  FROM $inventorytablename
  ''');
    List<String> item=[];
    for(int i=0;i<result.length;i++){
      item.add(result[i][inventorycolumn2name]);
    }
    return item;
  }
  Future<Map<String,dynamic>> searchbybarcode(String barcode)async{
    var db = await getdatabase();
    List<Map<String,dynamic>> temp=await db.query(inventorytablename,where: '$inventorycolumn10barcode = ?',whereArgs: [barcode]);
    return temp[0];
  }
  Future<List>  getproducdbarcode()async{
    var db = await getdatabase();
    List<Map<String, dynamic>> result = await db.rawQuery('''
  SELECT $inventorycolumn10barcode 
  FROM $inventorytablename
  ''');
    List<String> item=[];
    for(int i=0;i<result.length;i++){
      item.add(result[i][inventorycolumn10barcode]);
    }
    return item;
  }
  Future<List<Map<String,dynamic>>> searchbyname(String name)async{
    var db = await getdatabase();
    List<Map<String,dynamic>> temp=await db.query(inventorytablename,where: '$inventorycolumn2name = ?',whereArgs: [name]);
    return temp;
  }
  // Update record
  Future<bool> updateInventory({required int id,required String image,required String productname, required double perunitprice, required double perunitcost, required String description, required int noofunit,required double taxrate,required String categorie}) async {
    var db = await getdatabase();
    int roweffected = await db.update(
      inventorytablename, // Correct table name for the inventory
      {
        inventorycolumn2name: productname,
        inventorycolumn3price: perunitprice,
        inventorycolumn4description: description,
        inventorycolumn5nounit: noofunit,
        inventorycolumn6cost: perunitcost,
        inventorycolumn7image: image,
        inventorycolumn8taxrate :taxrate,
        inventorycolumn9categoriesname:categorie
      }, // Column to update
      where: '$inventorycolumn1sno = ?', // Condition with correct column name
      whereArgs: [id], // Value for the id condition
    );
    return roweffected > 0;
  }

  // Delete record
  Future<bool> deleteInventory({required int id}) async {
    var db = await getdatabase();
    int roweffected = await db.delete(
      inventorytablename, // Correct table name for the inventory
      where: '$inventorycolumn1sno = ?', // Condition with correct column name
      whereArgs: [id], // Value for the id condition
    );
    return roweffected > 0;
  }
}
