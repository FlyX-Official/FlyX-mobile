// import 'dart:convert';

// import 'dart:io';

// import 'package:flyxweb/models/Airlines/Airlines.dart';
// import 'package:flyxweb/models/Airlines/Operator.dart';
// import 'package:dio/dio.dart';

// main() async {
//   final _dio = Dio();
//   final stopwatch = Stopwatch()..start();
//   List<Airline> _data;
//   List<Operator> bus = [], train = [], airline = [];

//   await File("Airlines.json").readAsString().then((r) async {
//     _data = airlineFromJson(r);
//     _data.forEach((u) => u.type == 'bus'
//         ? bus.add(
//             Operator(
//               id: u.id,
//               lcc: u.lcc,
//               name: u.name,
//               logo: "https://images.kiwi.com/airlines/128/${u.id}.png",
//             ),
//           )
//         : u.type == 'train'
//             ? train.add(
//                 Operator(
//                   id: u.id,
//                   lcc: u.lcc,
//                   name: u.name,
//                   logo: "https://images.kiwi.com/airlines/128/${u.id}.png",
//                 ),
//               )
//             : u.type == 'airline'
//                 ? airline.add(
//                     Operator(
//                       id: u.id,
//                       lcc: u.lcc,
//                       name: u.name,
//                       logo: "https://images.kiwi.com/airlines/128/${u.id}.png",
//                     ),
//                   )
//                 : '');
//   });
//   final data = Map<String, dynamic>();
//   // List<Airline> airlines = airlineFromJson(_data);
//   // print(airlines);

//   // train.sort();
//   // airline.sort();

//   // data['airlineOperator'] = airline;
//   // data['busOperator'] = bus;
//   data['trainOperator'] = train;

//   data.forEach((k, v)async {
//    await _dio
//         .get(v[0].logo, options: Options(responseType: ResponseType.bytes))
//         .then((r) {
//       final file = File('imageBytes.json');
//       file.createSync();
//       file.writeAsBytesSync(r.data);
//     });
//   });
//   final file = File('Operator.json');
//   file.createSync();
//   file.writeAsStringSync(jsonEncode(data));

//   print('Created Map in ${stopwatch.elapsed}');
// }
