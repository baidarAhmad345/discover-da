import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_application_1/models/textstyle.dart';

class LikedInfo extends StatefulWidget {
  const LikedInfo({super.key});

  @override
  State<LikedInfo> createState() => _LikedInfoState();
}

class _LikedInfoState extends State<LikedInfo> {
  List gettedList = [];
  ftn() async {
    var box = Hive.box("info_box");
    gettedList = box.get("info");
    print(gettedList);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ftn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Text(
            "Click",
            style: textStyle.copyWith(fontSize: 15),
          ),
          onPressed: () async {
            var box = await Hive.openBox("box_1");
            box.put("Name", "Baidar ahmad");
            box.put("Details", {"Name": "Baidar ahmad", "class": 23});
            print(box.get("Name"));
            print(box.get("Details"));
            print(box.get("Details")["Name"]);
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("Hive"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: gettedList.length,
                  itemBuilder: (context, index) {
                    return gettedList.isEmpty
                        ? const Center(child: Text("Empty"))
                        : Column(
                            children: [
                              Container(
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
                                    gettedList[index].toString(),
                                    style: textStyle.copyWith(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                )),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          // var box = await Hive.openBox("info_box");
                                          // box.put("info", mapresponse!["text"]);

                                          var box = Hive.box("info_box");
                                          List tempList = box.get("info") ?? [];
                                          tempList.remove(
                                              gettedList[index].toString());
                                          box.put("info", tempList);
                                          gettedList = box.get("info") ?? [];
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.star,
                                          color: Colors.white,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          var txt =
                                              gettedList[index].toString();
                                          Share.share(txt);
                                        },
                                        child: const Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ]),
                              ),
                            ],
                          );
                    // : Center(child: Text(gettedList[index]));
                  }),
            ),
          ],
        ));
  }
}
