# flutter_json

A Flutter project of reading JSON data and making remote API calls.

## local JSON

To read from a local JSON file first there should be JSON file in the assets folder and declared in the pubspec.yaml file.

pubspec.yaml

    flutter:
      assets:
        - assets/data/arabalar.json

Now we need a model class of the data we will read and then we can fetch data from the file read it and use it in code. And if we want to load the data at initialization we can do so at the initState method and using FutureBuilder Widget.

araba_model.dart

    class Araba {
      final String arabaAdi;
      final String ulke;
      final String kurulusYili;
      final List<Model> model;

local_json.dart

    late final Future<List<Araba>> listeyiDoldur;

    @override
    void initState() {
      super.initState();
      listeyiDoldur = arabalarOku();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
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
        List<Araba> tumArabalar = (jsonObject as List)
            .map((arabaJson) => Araba.fromMap(arabaJson))
            .toList();
        return tumArabalar;
      } catch (e) {
        return Future.error(e.toString());
      }
    }

## Reading from Remote Api

In order to make api calls you first need Dio package, A powerful HTTP networking package for Dart/Flutter, supports Global configuration, Interceptors, FormData, Request cancellation, File uploading/downloading, Timeout, Custom adapters, Transformers, etc.

pubspec.yaml

    dependencies:
    flutter:
      sdk: flutter
  
    dio: ^5.9.0

We can now make api calls using Dio class. We will also need model classes that represents the data fetched from api.

user.dart

    class User {
    final int id;
    final String name;
    final String username;
    final String email;
    final Address address;
    final String phone;
    final String website;
    final Company company;

remote_api.dart

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
                  // Using the fetched data
