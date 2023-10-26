import 'dart:io';

import 'package:flutter/material.dart';

import '../Helper/sql_helper.dart';
import 'AddProductSheet.dart';

class ProductList extends StatefulWidget {
  ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Map<String, dynamic>> products = [];
  bool _isloading = true;

  void refreshProducts() async {
    final data = await SQLHelper.getItems();
    setState(() {
      products = data;
      print(products);
      _isloading = false;
      print('Number of items = ${products.length}');
    });
  }

  @override
  void initState() {
    refreshProducts();
    print('Number of items = ${products.length}');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text(
          'Product List',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: products.isNotEmpty
          ? ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange,
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: products[index]['product_image'] == ""
                            ? null
                            : FileImage(File(products[index]['product_image'])),
                      ),
                      title: Text(
                        products[index]['name'],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("NGN${products[index]['price']}"),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.production_quantity_limits, size: 15,),
                              Text("${products[index]['quantity']}"),
                            ],
                          ),
                          Text( products[index]['created_at'],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => AddProductBottomSheet(
                                    id: products[index]['id'],
                                    produuct: products,
                                  ),
                                ).then((value) => {
                                      if (value = true) {refreshProducts()}
                                    });
                              },
                              child: Icon(Icons.edit)),
                          GestureDetector(
                              onTap: () {
                                print(products[index]['id']);
                                deleteItem(products[index]['id']);
                              },
                              child: Icon(Icons.delete)),
                        ],
                      )),
                ),
              ),
            )
          : Center(
              child: Image.asset(
                "assets/images/empty.png",
                height: 200,
                width: 150,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => AddProductBottomSheet(
            id: null,
            produuct: products,
          ),
        ).then((value) => {
              if (value = true) {refreshProducts()}
            }),
        child: Icon(Icons.add),
      ),
    );
  }

  void deleteItem(int ID) async {
    SQLHelper.deleteItem(ID);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Item succesfully deleted')));
    refreshProducts();
  }
}
