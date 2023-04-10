import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final form = GlobalKey<FormState>();
  var isInIt = true;
  var isLoading = false;
  var inItValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  Product editedProduct = Product(
    description: '',
    id: null,
    price: 0.0,
    title: '',
    imageUrl: '',
  );
  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInIt) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = editedProduct.imageUrl;
        inItValues = {
          'title': editedProduct.title,
          'price': editedProduct.price.toString(),
          'description': editedProduct.description,
          // 'imageUrl': editedProduct.imageUrl,
        };
      }
    }
    isInIt = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void saveForm() {
    var isValid = form.currentState.validate();
    if (!isValid) {
      return;
    }
    form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(editedProduct)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Error!'),
                content: Text('Something went wrong'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('OK'),
                  )
                ],
              );
            });
      }).then((_) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
    // Navigator.of(context).pop();
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      // if (!_imageUrlController.text.startsWith('http') ||
      //     !_imageUrlController.text.startsWith('https')) {
      //   return;
      // }
      // if (!_imageUrlController.text.endsWith('.png') ||
      //     !_imageUrlController.text.endsWith('.png')) {return;}
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                  key: form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: inItValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (newValue) {
                          editedProduct = Product(
                              description: editedProduct.description,
                              id: editedProduct.id,
                              isFavorite: editedProduct.isFavorite,
                              price: editedProduct.price,
                              title: newValue,
                              imageUrl: editedProduct.imageUrl);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: inItValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a valid price.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          editedProduct = Product(
                              description: editedProduct.description,
                              id: editedProduct.id,
                              isFavorite: editedProduct.isFavorite,
                              price: double.parse(newValue),
                              title: editedProduct.title,
                              imageUrl: editedProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                        initialValue: inItValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        focusNode: _descriptionFocusNode,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length <= 10) {
                            return 'Minimum characters 10';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          editedProduct = Product(
                              description: newValue,
                              id: editedProduct.id,
                              isFavorite: editedProduct.isFavorite,
                              price: editedProduct.price,
                              title: editedProduct.title,
                              imageUrl: editedProduct.imageUrl);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8, right: 10),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(
                                    child: Text(
                                      'Enter Image URL',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.cover,
                                    child:
                                        Image.network(_imageUrlController.text),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              //! initialValue: inItValues['imageUrl'],
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter an image URL';
                                }
                                // if (!value.startsWith('http') ||
                                //     !value.startsWith('https')) {
                                //   return 'Please enter valid URL';
                                // }
                                // if (!value.endsWith('.png') ||
                                //     !value.endsWith('.png')) {
                                //   return 'Please enter valid image URL';
                                // }
                                return null;
                              },
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                saveForm();
                              },
                              onSaved: (newValue) {
                                editedProduct = Product(
                                    description: editedProduct.description,
                                    id: editedProduct.id,
                                    isFavorite: editedProduct.isFavorite,
                                    price: editedProduct.price,
                                    title: editedProduct.title,
                                    imageUrl: newValue);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
