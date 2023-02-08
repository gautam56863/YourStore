import 'package:flutter/material.dart';
import '../provider/product.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _pricefocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _edittedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    _imgUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(_updateImageUrl);
    _pricefocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlController.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    print(_edittedProduct.title);
    print(_edittedProduct.price);
    print(_edittedProduct.description);
    print(_edittedProduct.imageUrl);
    print(_edittedProduct.isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_pricefocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) return 'Please Provide a value';
                  return null;
                },
                onSaved: (value) {
                  _edittedProduct = Product(
                    id: null,
                    title: value,
                    description: _edittedProduct.description,
                    price: _edittedProduct.price,
                    imageUrl: _edittedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _pricefocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) return 'Please Provide a value';

                  if (double.tryParse(value) == null)
                    return 'Please enter a valid number';

                  if (double.parse(value) <= 0)
                    return 'Please enter a number greater than zero.';
                  return null;
                },
                onSaved: (value) {
                  _edittedProduct = Product(
                    id: null,
                    title: _edittedProduct.title,
                    description: _edittedProduct.description,
                    price: double.parse(value),
                    imageUrl: _edittedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) return 'Please Provide a value';
                  if (value.length < 10)
                    return 'Should be atleast 10 characters long.';
                  return null;
                },
                onSaved: (value) {
                  _edittedProduct = Product(
                    id: null,
                    title: _edittedProduct.title,
                    description: value,
                    price: _edittedProduct.price,
                    imageUrl: _edittedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsetsDirectional.all(5.0),
                    width: 100,
                    height: 100,
                    margin: const EdgeInsetsDirectional.only(
                      end: 10,
                      top: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imgUrlController.text.isEmpty
                        ? Text('Enter a URL!')
                        : FittedBox(
                            child: Image.network(_imgUrlController.text),
                            // fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imgUrlController,
                      focusNode: _imgUrlFocusNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                          id: null,
                          title: _edittedProduct.title,
                          description: _edittedProduct.description,
                          price: _edittedProduct.price,
                          imageUrl: value,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
