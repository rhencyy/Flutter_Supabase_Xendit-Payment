import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  // 20 Y2K Streetwear Products (5 bawat category)
  final List<Product> sampleProducts = [
    // HOODIES (5)
    Product(id: '1', name: 'VIGILANTE Cyber Hoodie', price: 1200.0, imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=500&q=80', category: 'Hoodies', sizes: ['S', 'M', 'L', 'XL']),
    Product(id: '2', name: 'Glitch Star Zip-Up', price: 1350.0, imageUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=500&q=80', category: 'Hoodies', sizes: ['S', 'M', 'L', 'XL']),
    Product(id: '3', name: 'Matrix Heavyweight Hoodie', price: 1400.0, imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=500&q=80', category: 'Hoodies', sizes: ['M', 'L', 'XL', 'XXL']),
    Product(id: '4', name: 'Underground Tech Hoodie', price: 1250.0, imageUrl: 'https://images.unsplash.com/photo-1548883354-7622d03aca27?auto=format&fit=crop&w=500&q=80', category: 'Hoodies', sizes: ['S', 'M', 'L']),
    Product(id: '5', name: 'Chrome Skull Pullover', price: 1300.0, imageUrl: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&w=500&q=80', category: 'Hoodies', sizes: ['S', 'M', 'L', 'XL']),

    // SHIRTS (5)
    Product(id: '6', name: 'Y2K Cyber Chrome Tee', price: 650.0, imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=500&q=80', category: 'Shirts', sizes: ['S', 'M', 'L', 'XL']),
    Product(id: '7', name: 'Vigilante Star Graphic Tee', price: 700.0, imageUrl: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?auto=format&fit=crop&w=500&q=80', category: 'Shirts', sizes: ['S', 'M', 'L', 'XL']),
    Product(id: '8', name: 'Retro Acid Wash Shirt', price: 750.0, imageUrl: 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=500&q=80', category: 'Shirts', sizes: ['M', 'L', 'XL']),
    Product(id: '9', name: 'Cyberpunk Boxy Tee', price: 680.0, imageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=500&q=80', category: 'Shirts', sizes: ['S', 'M', 'L', 'XL']),
    Product(id: '10', name: 'Minimalist Logo Tee', price: 600.0, imageUrl: 'https://images.unsplash.com/photo-1562157873-818bc0726f68?auto=format&fit=crop&w=500&q=80', category: 'Shirts', sizes: ['S', 'M', 'L']),

    // PANTS (5)
    Product(id: '11', name: 'Baggy Vintage Denim Pants', price: 1450.0, imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=500&q=80', category: 'Pants', sizes: ['28', '30', '32', '34']),
    Product(id: '12', name: 'Tactical Cargo Sweatpants', price: 1350.0, imageUrl: 'https://images.unsplash.com/photo-1517445312882-bc9910d016b7?auto=format&fit=crop&w=500&q=80', category: 'Pants', sizes: ['S', 'M', 'L', 'XL']),
    Product(id: '13', name: 'Parachute Utility Pants', price: 1500.0, imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=500&q=80', category: 'Pants', sizes: ['28', '30', '32', '34']),
    Product(id: '14', name: 'Dark Wash Street Jeans', price: 1400.0, imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&w=500&q=80', category: 'Pants', sizes: ['30', '32', '34', '36']),
    Product(id: '15', name: 'Techwear Ripstop Trousers', price: 1550.0, imageUrl: 'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?auto=format&fit=crop&w=500&q=80', category: 'Pants', sizes: ['S', 'M', 'L', 'XL']),

    // CAPS (5)
    Product(id: '16', name: 'Graffiti Y2K Trucker Cap', price: 450.0, imageUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?auto=format&fit=crop&w=500&q=80', category: 'Caps', sizes: ['Free Size']),
    Product(id: '17', name: 'Vigilante Chrome Snapback', price: 480.0, imageUrl: 'https://images.unsplash.com/photo-1534215712739-1634baf5776d?auto=format&fit=crop&w=500&q=80', category: 'Caps', sizes: ['Free Size']),
    Product(id: '18', name: 'Distressed Cyber Dad Cap', price: 420.0, imageUrl: 'https://images.unsplash.com/photo-1575428652377-a2d80e2277fc?auto=format&fit=crop&w=500&q=80', category: 'Caps', sizes: ['Free Size']),
    Product(id: '19', name: 'Mesh Streetwear Cap', price: 450.0, imageUrl: 'https://images.unsplash.com/photo-1521369909029-2afed882baee?auto=format&fit=crop&w=500&q=80', category: 'Caps', sizes: ['Free Size']),
    Product(id: '20', name: 'Star Logo Beanie', price: 390.0, imageUrl: 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?auto=format&fit=crop&w=500&q=80', category: 'Caps', sizes: ['Free Size']),
  ];

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = sampleProducts.where((p) {
      bool matchesCategory = selectedCategory == 'All' || p.category == selectedCategory;
      bool matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.star_border, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'VIGILANTE',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 18),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search streetwear...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),

          // Categories Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['All', 'Hoodies', 'Shirts', 'Pants', 'Caps'].map((cat) {
                bool isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.white,
                    backgroundColor: Colors.grey[900],
                    labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                    onSelected: (selected) {
                      if (selected) setState(() => selectedCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Product Grid View
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(product.imageUrl, width: double.infinity, fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('₱${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                onPressed: () => _showSizeSelectionModal(product),
                                child: const Text('Select Size', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSizeSelectionModal(Product product) {
    String selectedSize = product.sizes.first;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('₱${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  const Text('Select Size:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: product.sizes.map((s) {
                      bool isSelected = selectedSize == s;
                      return ChoiceChip(
                        label: Text(s),
                        selected: isSelected,
                        selectedColor: Colors.white,
                        backgroundColor: Colors.black,
                        labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
                        onSelected: (selected) {
                          if (selected) setModalState(() => selectedSize = s);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${product.name} (Size: $selectedSize) to Cart!')));
                      },
                      child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
