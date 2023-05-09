import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:foodwise/models/product.dart';
import 'package:foodwise/models/product_data.dart';
import 'package:provider/provider.dart';



class ProductTile extends StatelessWidget {
  final Product product;
  final Function onPressed;
  final Function onLongPressed;

  ProductTile({
    required this.product,
    required this.onPressed,
    required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    //Color dotColor;
    String formattedDate = DateFormat.yMd().format(product.expirationDate);
    Duration difference = product.expirationDate.difference(DateTime.now());

    Icon? icon;
    IconData iconData;
    Color dotColor = Colors.transparent;

    if (difference.inDays >= 6) {
      icon = Icon(
          Icons.thumb_up, color: Colors.green);
      dotColor = Colors.green;
    } else if (difference.inDays >= 2) {
      icon = Icon(
        IconData(0xf0233, fontFamily: 'MaterialIcons', matchTextDirection: true),
        color: Colors.yellow,
      );
      dotColor = Colors.yellow;
    } else {
      icon = Icon(
          Icons.thumb_down, color: Colors.red);
      dotColor = Colors.red;
    }


    return ListTile(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController nameController =
            TextEditingController(text: product.name);
            TextEditingController dateController = TextEditingController(
                text: DateFormat.yMd().format(product.expirationDate));

            return AlertDialog(
              title: Text('Edit Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(labelText: 'Expiration Date'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () {
                    String name = nameController.text;
                    DateTime date =
                    DateFormat.yMd().parse(dateController.text);
                    Provider.of<ProductData>(context, listen: false)
                        .updateProductById(product.id, name, date);
                    Navigator.of(context).pop();
                  },
                  child: Text('SAVE'),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Product'),
                          content: Text('Are you sure you want to delete "${product.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('CANCEL'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<ProductData>(context, listen: false)
                                    .deleteProductById(product.id);
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              child: Text('DELETE'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'DELETE',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      leading: icon,
      title: Row(
        children: [
          Text(
            product.name,
            style: TextStyle(
              decoration: product.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.circle, color: dotColor, size: 10.0),
        ],
      ),
      subtitle: Text(formattedDate),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          Provider.of<ProductData>(context, listen: false)
              .deleteProductById(product.id);
        },
      ),
    );
  }
}
