import 'dart:convert';
import 'package:flutter/material.dart';
import 'model/araba_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({super.key});

  @override
  State<LocalJson> createState() => _StateLocalJson();
}

class _StateLocalJson extends State<LocalJson> {

  String _title = "Local JSON işlemleri";

  late final Future<List<Araba>> listeyiDoldur;

  @override
  void initState() {
    super.initState();
    listeyiDoldur = arabalarOku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        setState(() {
          _title = "Button tıklandı";
        });
      }),
      appBar: AppBar(title: Text(_title)),
      body: FutureBuilder<List<Araba>>(
        future: listeyiDoldur,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Araba>? arabalar = snapshot.data;
            return ListView.builder(itemCount: arabalar?.length,itemBuilder: (context, index) {
              var oankiAraba = arabalar![index];
              return ListTile(
                title: Text(oankiAraba.arabaAdi),
                subtitle: Text(oankiAraba.ulke),
                leading: CircleAvatar(
                  radius: 25,
                  child: Text(oankiAraba.model[0].fiyat.toString()),
                ),
              );
            });
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<Araba>> arabalarOku() async {
    try {
      String okunanString = await DefaultAssetBundle.of(
        context,
      ).loadString("assets/data/arabalar.json");
      var jsonObject = jsonDecode(okunanString);
      /*print(okunanString);
      print("-----------------------");
      print(jsonObject);
      print("-----------------------");*/
      //List arabaListesi = jsonObject;
      //print(arabaListesi[0]["model"][0]["fiyat"]);
      List<Araba> tumArabalar = (jsonObject as List)
          .map((arabaJson) => Araba.fromMap(arabaJson))
          .toList();
      debugPrint(tumArabalar[0].model[0].modelAdi);
      debugPrint(tumArabalar.length.toString());
      return tumArabalar;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
