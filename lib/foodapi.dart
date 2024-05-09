import 'package:flutter/material.dart';
import 'package:nutrition_app/detailsscreen.dart';
import 'package:nutrition_app/foodlist.dart';

class foodapi extends StatefulWidget {
  const foodapi({super.key});

  @override
  State<foodapi> createState() => _foodapiState();
}

class _foodapiState extends State<foodapi> {
  var foodlist =FoodList();
  List<FoodList> _foodlist =[];

  void initState(){
    _foodlist= foodlist.foodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Nutrients"),),
      body: ListView.builder(
        itemCount: _foodlist.length,
          itemBuilder: (context,index){
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(_foodlist[index].id)),);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("${_foodlist[index].name}"),
            Text("${_foodlist[index].foodCategory}"),
          ],),
        );
      }),
    );
  }
}
