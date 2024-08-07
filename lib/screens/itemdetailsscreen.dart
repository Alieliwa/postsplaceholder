
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Map item;

  ItemDetailsScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details',style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              item['title'],
              style: const TextStyle(fontSize: 24,color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            const  SizedBox(height: 16),
            Text(item['body'],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w300),),
          ],
        ),
      ),
    );
  }
}