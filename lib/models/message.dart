// class Message {
//   final String message;
//
//   Message({required this.message});
//
//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//     };
//   }
// }
// lib/models/message.dart

//working properly code
class Message {
  final String message;

  Message({required this.message});

  Map<String, dynamic> toJson() {
    return {
      'patient_message': message,
    };
  }
}


