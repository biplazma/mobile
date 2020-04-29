class User {
  String uid;
  String name;
  String gender;
  String phone;
  String email;
  String bloodGroup;
  String address;
  String role;
  String photo;

  User({this.uid, this.name, this.gender, this.email, this.bloodGroup, this.address, this.phone, this.photo, this.role});

  User.fromMap(Map snapshot, String id) {
    uid = id ?? '';
    name = snapshot['displayName'] ?? "";
    gender = snapshot['gender'] ?? "";
    email = snapshot['email'] ?? '';
    bloodGroup = snapshot['bloodGroup'] ?? '';
    address = snapshot['address'] ?? '';
    phone = snapshot['phone'] ?? '';
    photo = snapshot['photo'] ?? '';
    role = snapshot['img'] ?? '';
  }

  toJson() {
    return {
      "uid": uid,
      "name": name,
      "gender": gender,
      "phone": phone,
      "email": email,
      "bloodGroup": bloodGroup,
      "address": address,
      "photo": photo,
      "role": role,
    };
  }
}
