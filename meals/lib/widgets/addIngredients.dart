import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddIngredients extends StatefulWidget {
  const AddIngredients({super.key, required this.saveIngredients});

  final Function(List<String>) saveIngredients;

  @override
  State<StatefulWidget> createState() {
    return _AddIngredientsState();
  }
}

class _AddIngredientsState extends State<AddIngredients> {
  final _amountController = TextEditingController();
  final List<String> _listOfIngredients = [];
  final _formKey = GlobalKey<FormState>();
  bool _canShowSaveButton = false;

  var amountOfTextfield = 0;

  bool _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.saveIngredients(_listOfIngredients);
      print(_listOfIngredients);
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: ((context) => CupertinoAlertDialog(
              title: const Text('Invalid input'),
              content: const Text(
                  'Please selcet the amount of ingredients you want to add to the recipe'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Okay'))
              ],
            )),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please selcet the amount of ingredients you want to add to the recipe'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'))
          ],
        ),
      );
    }
  }

  void _setAmountOfTextfields() {
    final _amountOfTextFields = int.tryParse(_amountController.text);
    if (_amountOfTextFields != null) {
      setState(() {
        amountOfTextfield = _amountOfTextFields;
        _canShowSaveButton = true;
      });
      print(amountOfTextfield);
    } else {
      _showDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              children: [
                const Text(
                  'Add Ingredients',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text('How many ingredients do you want to add?'),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _setAmountOfTextfields();
                  },
                  child: const Text('Confirm'),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      for (var i = 0; i < amountOfTextfield; i++)
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Ingredient ${i + 1}'),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length <= 1) {
                              return 'Wrong input';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            _listOfIngredients.add(newValue!);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                _canShowSaveButton
                    ? ElevatedButton(
                        onPressed: () {
                          if (_saveItem()) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add ingredients'),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
