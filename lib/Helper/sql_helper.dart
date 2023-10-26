import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart'  as sql;
import 'package:sqflite/sql.dart';
class SQLHelper{
  static Future<void>createTables(sql.Database database)async {
   await database.execute("""CREATE TABLE "product_manager"(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    product_image TEXT,
    price REAL,
    quantity INTEGER,
    name TEXT
   )""");
  }


  static Future<sql.Database> db() async{
    return sql.openDatabase(
      "product.db",
      version: 1,
      onCreate: (sql.Database database, int version) async{
        print('creating a table');
        await createTables(database);
      }
    );
  }


  static Future<int> createItem(String productImage, String price, String quantity, String name)async{
    final db = await SQLHelper.db();

     final data = {
    'created_at': DateTime.now().toString(),
    'product_image': productImage,
    'price': price,
    'quantity': quantity,
    'name': name,
  };
    final id = await db.insert("product_manager", data);
    sql.ConflictAlgorithm.replace;
   // conflictAlgorithm: sql.ConflictAlgorithm.replace;
    return id;
  }

  //get the items from the table
  //This returns a list of maps
  static Future<List<Map<String, dynamic>>>getItems() async{
    final db = await SQLHelper.db();
    return db.query('product_manager', orderBy: 'id');
  }

  //to get just one of the product
  static Future <List<Map<String, dynamic>>> getanItem() async{
    final db = await SQLHelper.db();
    return db.query('product_manager', where: 'id = ?', whereArgs: ['id'], limit: 1);
  }


  //update Item
  static Future <int> updateItem (int id, String price, String quantity, String name)async{
    final db = await SQLHelper.db();
      final data = {'price': price, 'name': name, "quantity": quantity};

      final result = await db.update('product_manager', data, where: "id=?", whereArgs: ['id']);
      return result;
  }

  //delete item
   static Future <void> deleteItem (int id)async{
    final db = await SQLHelper.db();
     
     try{
       await db.delete("product_manager", where: "id = ?", whereArgs: [id]);
     }catch(error){
      debugPrint(error.toString());
     }
  }
}