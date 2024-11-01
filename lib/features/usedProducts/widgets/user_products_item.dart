import 'package:flutter/material.dart';
import 'package:miogra/core/product_box.dart';
import 'package:miogra/features/shopping/presentation/pages/shopping_product_details_page.dart';
import 'package:miogra/features/usedProducts/controllers/user_product_form_controllers.dart';

class UsedProductsItem extends StatelessWidget {
  const UsedProductsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          primary: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: .8,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return productBox(
              rating: 0,
              imageUrl: 'assets/images/home-theater.jpeg',
              pName: 'Home Theater',
              oldPrice: 7000,
              newPrice: 5000,
              offer: 30,
              color: const Color(0x6B870081),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductDetails(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

TextField productDetailsFormTextField({
  required TextEditingController controller,
  required String label,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: label,
    ),
  );
}

class CustomFormTextField extends StatefulWidget {
  final int index;
  final TextEditingController titleController, valueController;
  const CustomFormTextField(
      {super.key,
      required this.index,
      required this.titleController,
      required this.valueController});

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Title"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: TextField(
              controller: widget.valueController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Value",
              ),
            ),
          ),
          Expanded(
            child: IconButton(
                onPressed: () {
                  setState(() {
                    textEditingControllers.removeAt(widget.index);
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ),
        ],
      ),
    );
  }
}
