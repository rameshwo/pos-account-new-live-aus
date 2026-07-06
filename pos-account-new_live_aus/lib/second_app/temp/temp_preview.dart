// //TODO: remove it later dual screen

// import 'package:flutter/material.dart';
// import 'package:pos_account/env.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import '../second_screen/second_screen.dart';

// class TempPreview extends StatefulWidget {
//   final Widget child;
//   const TempPreview({super.key, required this.child}) ;

//   @override
//   State<TempPreview> createState() => _TempPreviewState();
// }

// class _TempPreviewState extends State<TempPreview>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 400),
//     );
//     _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }

//   //
//   Alignment _preAlign = Alignment.bottomRight;

//   void load() {
//     if (mounted) setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         widget.child,
//         if (GlobalCVP.isDualMainScreen &&
//             AppEnviro.enviroment == Enviroment.DEV)
//           AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return Transform.scale(
//                     scale: _animation.value,
//                     alignment: _preAlign,
//                     child: Card(
//                         elevation: 4,
//                         child: Stack(
//                           // alignment: Alignment.bottomLeft,
//                           children: [
//                             // InitSecondApp(),
//                             SecondScreen(),
//                             Align(
//                               alignment: Alignment.bottomLeft,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(bottom: 40),
//                                 child: IconButton(
//                                     onPressed: () {
//                                       if (_controller.isCompleted) {
//                                         _controller.reverse();
//                                       } else {
//                                         _controller.forward();
//                                       }
//                                     },
//                                     icon: Icon(
//                                       _animation.value == 1
//                                           ? Icons.fullscreen_exit
//                                           : Icons.fullscreen_outlined,
//                                       size: 72,
//                                     )),
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.bottomRight,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(48.0),
//                                 child: IconButton(
//                                     onPressed: () {
//                                       if (_preAlign == Alignment.bottomRight)
//                                         _preAlign = Alignment.topRight;
//                                       else if (_preAlign == Alignment.topRight)
//                                         _preAlign = Alignment.topLeft;
//                                       else if (_preAlign == Alignment.topLeft)
//                                         _preAlign = Alignment.bottomLeft;
//                                       else
//                                         _preAlign = Alignment.bottomRight;
//                                       load();
//                                     },
//                                     icon: Icon(
//                                       Icons.move_down_outlined,
//                                       size: 72,
//                                     )),
//                               ),
//                             )
//                           ],
//                         )));
//               }),
//       ],
//     );
//   }
// }
