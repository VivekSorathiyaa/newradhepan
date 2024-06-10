// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopbook/app/utils/colors.dart';

class SearchDropDownWidget extends StatefulWidget {
  final Function(dynamic, dynamic)? onSelect;
  final List? searchData;
  final String? searcPlaceHolder;

  const SearchDropDownWidget({
    Key? key,
    this.onSelect,
    this.searchData,
    @required this.searcPlaceHolder,
  }) : super(key: key);

  @override
  _SearchDropDownWidgetState createState() => _SearchDropDownWidgetState();
}

class _SearchDropDownWidgetState extends State<SearchDropDownWidget> {
  List? searchedData;
  final SearchBouncer _searchBouncer = SearchBouncer(milliSecond: 100);

  search(value) {
    searchedData = widget.searchData!.where((c) {
      return (c.toString().toLowerCase())
          .contains(value.toString().toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    searchedData = widget.searchData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: TextWidget(
                labelText: widget.searcPlaceHolder ?? "Search",
                onChanged: (value) {
                  _searchBouncer.run(() {
                    setState(() {
                      search(value);
                    });
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchedData!.length,
                itemBuilder: (_, i) {
                  List stringData = searchedData![i]
                      .toString()
                      .substring(1, searchedData![i].toString().length - 1)
                      .split(":");
                  return InkWell(
                    child: ListTile(
                      onTap: () {
                        widget.onSelect!(stringData[0], stringData[1]);
                      },
                      title: Text("${stringData[1]}"),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ), // showCard(context),
      ),
    );
  }
}

class SearchDropDown extends StatelessWidget {
  final List? searchList;
  final Function(dynamic, dynamic)? onChange;
  // ignore: prefer_typing_uninitialized_variables
  final initialValue;
  final String? labelValue;
  final String? searchPlaceHolder;
  const SearchDropDown({
    Key? key,
    this.searchList,
    this.onChange,
    this.initialValue,
    this.labelValue,
    @required this.searchPlaceHolder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SearchDropDownWidget(
                searchData: searchList,
                searcPlaceHolder: searchPlaceHolder,
                onSelect: (code, title) {
                  onChange!(code, title);
                  Navigator.pop(context);
                },
              );
            });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          // border: Border.all(color: darkSilver),
          color: offWhite,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.only(left: 10, right: 5),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: initialValue != null
                  ? Text(
                      "$initialValue",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  : Text(
                      "$labelValue",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
            ),
            const Expanded(
              flex: 1,
              child: Icon(Icons.keyboard_arrow_down_rounded),
            )
          ],
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TextWidget({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.filled,
    this.prefixIcon,
    this.controller,
    this.enabled,
    this.focusNode,
    this.textCapitalization,
    this.onTap,
    this.maxLines,
    this.initialValue,
    this.style,
    this.maxLength,
    this.suffixIcon,
    this.onChanged,
  });

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? filled;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final bool? enabled;
  final FocusNode? focusNode;

  final TextCapitalization? textCapitalization;
  final GestureTapCallback? onTap;
  final int? maxLines;
  final String? initialValue;
  final TextStyle? style;
  final int? maxLength;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.text,
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      focusNode: focusNode,
      enabled: enabled,
      key: fieldKey,
      controller: controller,
      onSaved: onSaved,
      // validator: (value) => Validators.validateRequired(value, "This field"),
      validator: validator,
      onTap: onTap,
      maxLength: maxLength,
      // maxLengthEnforced: true,
      autofocus: false,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      style: style,
      onChanged: onChanged,

      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkSilver),
            borderRadius: BorderRadius.circular(8)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkSilver),
            borderRadius: BorderRadius.circular(8)),
        fillColor: whiteColor,
        filled: true,
        hintText: hintText,
        counterText: "",
        suffixIcon: suffixIcon,
        labelText: labelText,
        helperText: helperText,
      ),
    );
  }
}

class SearchBouncer {
  Timer? _timer;
  final int milliSecond;
  VoidCallback? action;

  SearchBouncer({required this.milliSecond});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliSecond), action);
  }

  static filterList(List list, String searchText) {
    List searchList = list;
    /*searchList.map((e) => null);*/
    searchList.where((c) {
      return (c.country.toLowerCase()).contains(searchText.toLowerCase());
    });
    return searchList;
  }
}
