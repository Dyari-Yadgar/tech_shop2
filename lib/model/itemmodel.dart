
class itemModel {
  late String name;
  late int price;
  late int storage;
  late String sharika;
  late String image;

  itemModel.fromJson(Map<String, dynamic> data) {
    //nawa fromJson
    // ba map aegareneneawa
    name = data['name'];
    price= data['price'];
    storage= data['storage'];
    sharika= data['sharika'];
    image= data['image'];
  }
}