import 'package:flutter/material.dart';
import 'package:online_food_order/models/post.dart';

class CartPage extends StatefulWidget {
  final List<Post> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<Post, int> _quantities = {};

  @override
  void initState() {
    super.initState();

    for (var item in widget.cartItems) {
      print("Item: ${item.foodName}, Price: ${item.price}");
      _quantities[item] = 1;
    }
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    _quantities.forEach((item, quantity) {
      total += ((item.price ?? 0.0) as double) * quantity;
    });
    return total;
  }

  void _incrementQuantity(Post item) {
    setState(() {
      _quantities[item] = (_quantities[item] ?? 0) + 1;
    });
  }

  void _decrementQuantity(Post item) {
    setState(() {
      if ((_quantities[item] ?? 0) > 1) {
        _quantities[item] = (_quantities[item] ?? 0) - 1;
      } else {
        _quantities.remove(item); // Remove item if quantity goes below 1
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cart Page', style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20),),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _quantities.keys.length,
              itemBuilder: (context, index) {
                final item = _quantities.keys.elementAt(index);
                final quantity = _quantities[item] ?? 1;

                return Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      item.foodImage ?? '',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(item.foodName ?? 'No Name'),
                    subtitle: Text(
                      'Price: ${(item.price ?? 0.0).toStringAsFixed(2)} BDT',
                    ),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _decrementQuantity(item),
                          ),
                          Text('$quantity'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _incrementQuantity(item),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(
                  'Total: ${_calculateTotalPrice().toStringAsFixed(2)} BDT',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle proceed to checkout
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Proceeding to checkout...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),

                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 16, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
