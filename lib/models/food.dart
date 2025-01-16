// //model class
// class Food {
//   String? foodName;
//   String? foodImage;
//   String? price;
//
//
//   //constructor
//   Food({
//     required this.price,
//     required this.foodName,
//     required this.foodImage,
//   });
//   Map<String, dynamic> toJson() {
//     return {
//       'price': price,
//       'foodName': foodName,
//       'foodImage': foodImage,
//     };
//   }
//   static Food fromJson(Map<String,dynamic> json){
//     return Food(
//       price: json['price'],
//       foodName:json['foodName'],
//       foodImage:json['foodImage'],
//     );
//   }
// }