// import 'package:flutter/material.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/pos_setting/com/printer_list_dia_2.dart';

// class PrinterTimingScreen extends StatelessWidget {
//   const PrinterTimingScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final timings = PrintTiming;
//     return Scaffold(
//       appBar: AppBar(title: const Text('Printer Timings')),
//       body: ListView.builder(
//         itemCount: timings.length,
//         itemBuilder: (context, index) {
//           final printer = timings[index];
//           return Card(
//             margin: const EdgeInsets.all(8),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("🖨️ ${printer.printerName} (${printer.printerType})",
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   _buildTiming("Status Check", printer.statusCheck),
//                   _buildTiming("Capture", printer.capture),
//                   _buildTiming("Image Data", printer.imageData),
//                   if (printer.print != null)
//                     ...List.generate(printer.print!.length, (i) {
//                       return _buildTiming("Print ${i + 1}", printer.print![i]);
//                     }),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTiming(String title, TaskTiming? timing) {
//     final _duration = timing?.endTime.difference(timing.startTime);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("🔹 $title", style: const TextStyle(fontWeight: FontWeight.w600)),
//         Text("   Start: ${timing?.startTime.toIso8601String()}"),
//         Text("   End: ${timing?.endTime.toIso8601String()}"),
//         Text("   Duration: ${_duration?.inSeconds} seconds"),
//         const SizedBox(height: 6),
//       ],
//     );
//   }
// }
