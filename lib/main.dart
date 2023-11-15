import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == "user" && password == "password") {
      // Login berhasil, lanjutkan ke halaman produk
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductListPage()),
      );
    } else {
      print("Login gagal. Periksa kembali username dan password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigasi langsung ke halaman produk tanpa login (untuk keperluan pengembangan)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListPage()),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  String name;
  int price;

  Product(this.name, this.price);
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> productList = [
    Product("Product Bando", 100000),
    Product("Product Minuman", 150000),
    Product("Product Sepatu", 75000),
    Product("Product Bando 2", 120000),
    Product("Product Baju", 90000),
    Product("Product Pants", 180000),
    Product("Product Topi", 200000),
    Product("Product Makeup", 85000),
    Product("Product Handphone", 160000),
    Product("Product Laptop", 130000),
  ];

  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(productList);
  }

  void _searchProducts(String query) {
    setState(() {
      filteredProducts = productList
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      productList.removeAt(index);
      filteredProducts = List.from(productList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Kembali ke halaman login setelah logout
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchProducts,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredProducts[index].name),
                  subtitle: Text(
                      'Harga: Rp ${filteredProducts[index].price.toString()}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Munculkan dialog konfirmasi penghapusan
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Konfirmasi'),
                            content: Text(
                                'Apakah Anda yakin ingin menghapus ${filteredProducts[index].name}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Tutup dialog konfirmasi
                                  Navigator.of(context).pop();
                                },
                                child: Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Hapus produk dan tutup dialog
                                  _deleteProduct(index);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Hapus'),
                              ),
                            ],
                          );
                        },
                      );
                    },
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
