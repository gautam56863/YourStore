import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';

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
  bool _isInit = true;
  bool _isLoading = false;
  var _inItValues = {
    'title': '',
    'price': '',
    'description': '',
    'imgUrl': '',
  };
  var _edittedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prodId = ModalRoute.of(context).settings.arguments as String;

      if (prodId != null) {
        _edittedProduct =
            Provider.of<Products>(context, listen: false).findbyId(prodId);
        _inItValues = {
          'title': _edittedProduct.title,
          'price': _edittedProduct.price.toString(),
          'description': _edittedProduct.description,
          // 'imgUrl': _edittedProduct.imageUrl,
          'imgUrl': '',
        };
        _imgUrlController.text = _edittedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      if ((!_imgUrlController.text.startsWith('http') &&
              !_imgUrlController.text.startsWith('https')) ||
          (!_imgUrlController.text.endsWith('.jpg') &&
              !_imgUrlController.text.endsWith('.png') &&
              !_imgUrlController.text.endsWith('.jpeg'))) return;
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    if (_edittedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_edittedProduct.id, _edittedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_edittedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occured!'),
            content: Text('Somethig Went Wrong!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = true;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = true;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _inItValues['title'],
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
                          id: _edittedProduct.id,
                          isFavorite: _edittedProduct.isFavorite,
                          title: value,
                          description: _edittedProduct.description,
                          price: _edittedProduct.price,
                          imageUrl: _edittedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _inItValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _pricefocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
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
                          id: _edittedProduct.id,
                          isFavorite: _edittedProduct.isFavorite,
                          title: _edittedProduct.title,
                          description: _edittedProduct.description,
                          price: double.parse(value),
                          imageUrl: _edittedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _inItValues['description'],
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
                          id: _edittedProduct.id,
                          isFavorite: _edittedProduct.isFavorite,
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
                          // padding: EdgeInsetsDirectional.all(5.0),
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an Image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https'))
                                return 'Please enter a Valid URL.';

                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('.jpeg'))
                                return 'Please enter a Valid image URL.';
                              return null;
                            },
                            onSaved: (value) {
                              _edittedProduct = Product(
                                id: _edittedProduct.id,
                                isFavorite: _edittedProduct.isFavorite,
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
