import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json/model/user.dart';

class RemoteApi extends StatefulWidget {
  const RemoteApi({super.key});

  @override
  State<RemoteApi> createState() => _RemoteApiState();
}

class _RemoteApiState extends State<RemoteApi> {

  Future<List<User>> _getUsers() async {
    try{
      var response = await Dio().get("https://jsonplaceholder.typicode.com/users");
      List<User> userList = [];
      if(response.statusCode == 200){
        userList = (response.data as List).map((element) => User.fromMap(element)).toList();
      }
      return userList;
    } on DioException catch(e){
      return Future.error(e);
    }
  }

  late final Future<List<User>> getUserList;

  @override
  void initState() {
    super.initState();
    getUserList = _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Remote Api with dio")),
      body: Center(
        child: FutureBuilder<List<User>>(
            future: getUserList,
            builder: (context, snapshot){
              if(snapshot.hasData){
                var userList = snapshot.data!;
                return ListView.builder(itemCount: userList.length, itemBuilder: (context, index){
                  var user = userList[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.address.toString()),
                    leading: Text(user.id.toString()),
                  );
                });
              } else if(snapshot.hasError){
                return Text(snapshot.error.toString());
              } else{
                return CircularProgressIndicator();
              }
            })
      ),
    );
  }
}
