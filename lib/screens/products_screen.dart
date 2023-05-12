import 'package:flutter/material.dart';
import 'package:FoodWise/widgets/products_list.dart';
import 'package:FoodWise/screens/add_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:FoodWise/models/product_data.dart';
import 'package:FoodWise/screens/qr_scanner_screen.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/fruitguy.png"),
            fit: BoxFit.none,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    top: 285.0, left: 30.0, right: 30.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /*CircleAvatar(
                      child: Icon(
                        Icons.list,
                        size: 30.0,
                        color: Colors.lightBlueAccent,
                      ),
                      backgroundColor: Colors.white,
                      radius: 30.0,
                    ),*/
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'FoodWise',
                      style: TextStyle(
                        color: Colors.red,
                        backgroundColor: Colors.white.withOpacity(0.7),
                        fontSize: 50.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${Provider.of<ProductData>(context).productCount} Products',
                      style: TextStyle(
                        color: Colors.purple,
                          backgroundColor: Colors.white.withOpacity(0.7),
                          fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: ProductsList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 20.0,
            bottom: 20.0,
            child: FloatingActionButton(
              backgroundColor: Color(0xFFB6EBD0),
              child: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: AddProductScreen(),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 50.0,
            bottom: 20.0,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF311A79),
              child: Icon(Icons.qr_code_scanner),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
