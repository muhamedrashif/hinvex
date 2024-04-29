// import 'dart:io';
// import 'package:http/http.dart' as http;

// void main() async {
//   final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

//   print('Server running on localhost:${server.port}');

//   server.listen((HttpRequest request) async {
//     // Set CORS headers to allow requests from any origin
//     request.response.headers.add('Access-Control-Allow-Origin', '*');
//     request.response.headers
//         .add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
//     request.response.headers
//         .add('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');

//     // Handle preflight OPTIONS requests
//     if (request.method == 'OPTIONS') {
//       request.response.statusCode = HttpStatus.ok;
//       await request.response.close();
//       return;
//     }

//     // Handle other requests
//     // Here you might want to add logic to serve your Flutter web application
//   });
// }
