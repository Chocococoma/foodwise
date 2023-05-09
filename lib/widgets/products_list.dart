import 'package:flutter/material.dart';
import 'package:foodwise/widgets/product_tile.dart';
import 'package:provider/provider.dart';
import 'package:foodwise/models/product_data.dart';

class ProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductData>(
      builder: (context, productData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final product = productData.products[index];
            return ProductTile(
              product: product,
              onPressed: () {
                productData.updateProduct(product);
              },
              onLongPressed: () {
                productData.deleteProduct(product);
              },
            );
          },
          itemCount: productData.productCount,
        );
      },
    );
  }
}
