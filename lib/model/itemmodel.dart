
class itemModel {
  late String name;
  late int price;
  late int id;
  late int storage;
  late String sharika;
  late String image;
  late String spec;

  itemModel.fromJson(Map<String, dynamic> data) {
    spec = data['spec'];
    id = data['id'];
    name = data['name'];
    price= data['price'];
    storage= data['storage'];
    sharika= data['sharika'];
    image= data['image'];
  }

  
}