class TodoModel {
  String title = '';
  bool done = false;
  int id = 1;
  String docId = '';

  TodoModel(Map<String, dynamic> json) {
    title = json["title"];
    done = json["done"];
    id = json["id"];
    docId = json["docId"];
  }

//  TodoModel(this.title, this.done, this.id});

//  ImageModel(Map<String, dynamic> json) {
//    _id = json["id"];
//    _imageUrl = json["image_url"];
//  }

//  String get title => _title;
//  bool get done => _done;
//  int get id => _id;
}
