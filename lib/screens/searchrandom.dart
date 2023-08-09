import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/helper.dart';
import 'package:flutter_application_1/models/textstyle.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class Searchbyrandom extends StatefulWidget {
  const Searchbyrandom({super.key});

  @override
  State<Searchbyrandom> createState() => _SearchbyrandomState();
}

class _SearchbyrandomState extends State<Searchbyrandom> {
  // Initial Selected Value
  String dropdownvalue = 'random';

  // List of items in our dropdown menu
  var items = [
    'year',
    'math',
    'random',
  ];

  Map? mapresponse;
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  searcher({required String searchNumber}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    String url;
    if (dropdownvalue == "random") {
      url = "http://numbersapi.com/random?json";
    } else {
      url = "http://numbersapi.com/random/$dropdownvalue?json";
    }
    var response = await http.get(Uri.parse(url));
    if (await Helper.isNotConnected()) {
      setState(() {
        isLoading = false;
        errorMessage = 'No intenet connection';
      });
      return;
    } else if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        var jsonbodydata = json.decode(response.body);
        mapresponse = jsonbodydata;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "search for random",
          style: textStyle.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(2, 140, 127, 1),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: 200,
            child: DropdownButton(
              focusColor: const Color.fromRGBO(144, 144, 144, 1),
              dropdownColor: const Color.fromRGBO(244, 244, 244, 1),
              isExpanded: true,
              // Initial Value
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(
                    items,
                    style:
                        textStyle.copyWith(color: Colors.black, fontSize: 18),
                  ),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(2, 140, 127, 1),
                foregroundColor: Colors.white),
            onPressed: () async {
              if (await Helper.isNotConnected()) {
                setState(() {
                  isLoading = false;
                  errorMessage = 'No intenet connection';
                });
              } else {
                final searchnumber = controller.text.trim();
                searcher(searchNumber: searchnumber);
              }
            },
            child: Text(
              "search",
              style: textStyle.copyWith(fontSize: 20),
            ),
          ),
          SizedBox(
            height: size.height * 0.10,
          ),
          if (isLoading)
            const Center(
                child: CircularProgressIndicator(
              color: Color.fromRGBO(2, 140, 127, 1),
            ))
          else if (errorMessage.isNotEmpty)
            Center(
              child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(244, 244, 244, 1),
                      borderRadius: BorderRadius.circular(10)),
                  height: size.height * 0.25,
                  width: size.width * 0.83,
                  child: Center(child: Text(errorMessage))),
            )
          else
            Column(
              children: [
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    height: 250,
                    width: 320,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        mapresponse?["text"].toString() ?? '',
                        style: textStyle.copyWith(
                            fontSize: 15, color: Colors.black),
                      ),
                    )),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(144, 144, 144, 1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  width: 320,
                  height: 40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        InkWell(
                          onTap: () {
                            var mapdata = mapresponse!["text"].toString();
                            Share.share(mapdata);
                          },
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        )
                      ]),
                ),
              ],
            ),
        ],
      )),
    );
  }
}
