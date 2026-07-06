// import 'dart:typed_data';
// import 'package:crop_your_image/crop_your_image.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/repository/if_exception.dart';
// import 'package:pos_account/widgets/loading.dart';

// import '../../ln.dart';

// /// free, 4:5, 1:1, 1:2, 3:2, 4:3, 16:9, 25:9
enum AspectRatioEnum { Free, R_1_1, R_1_2, R_3_2, R_4_3, R_16_9, R_25_9 }

class ImgAspectRatio {
  final double? ratio;
  final AspectRatioEnum ratioEnum;
  final String title;

  ImgAspectRatio({
    this.ratio,
    required this.ratioEnum,
    required this.title,
  });
}

// final _imageAspectRatio = <ImgAspectRatio>[
//   ImgAspectRatio(ratioEnum: AspectRatioEnum.Free, title: "Free"),
//   ImgAspectRatio(ratio: 1 / 1, ratioEnum: AspectRatioEnum.R_1_1, title: "1:1"),
//   ImgAspectRatio(ratio: 1 / 2, ratioEnum: AspectRatioEnum.R_1_2, title: "1:2"),
//   ImgAspectRatio(ratio: 3 / 2, ratioEnum: AspectRatioEnum.R_3_2, title: "3:2"),
//   ImgAspectRatio(ratio: 4 / 3, ratioEnum: AspectRatioEnum.R_4_3, title: "4:3"),
//   ImgAspectRatio(
//       ratio: 16 / 9, ratioEnum: AspectRatioEnum.R_16_9, title: "16:9"),
//   ImgAspectRatio(
//       ratio: 25 / 9, ratioEnum: AspectRatioEnum.R_25_9, title: "25:9")
// ];

// class ImageCropSection extends StatefulWidget {
//   final Uint8List image;
//   final ImgAspectRatio? imgAspectRatio;
//   const ImageCropSection({
//     super.key,
//     required this.image,
//     this.imgAspectRatio,
//   });

//   @override
//   State<ImageCropSection> createState() => _ImageCropSectionState();
// }

// class _ImageCropSectionState extends State<ImageCropSection> {
//   ImgAspectRatio _aspectRatio = _imageAspectRatio.first;

//   final _controller = CropController();

//   bool loading = false;

//   void load() {
//     if (mounted) setState(() {});
//   }

//   @override
//   void initState() {
//     if (widget.imgAspectRatio != null) {
//       _aspectRatio = widget.imgAspectRatio!;
//       load();
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Processing(
//           loading: loading,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ...List.generate(
//                       _imageAspectRatio.length,
//                       (index) => Expanded(
//                             child: TextButton(
//                                 onPressed: () {
//                                   _aspectRatio = _imageAspectRatio[index];
//                                   load();
//                                   _controller.aspectRatio = _aspectRatio.ratio;
//                                 },
//                                 child: Text(
//                                   _imageAspectRatio[index].title,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontFamily: kFontFMedium,
//                                     color: _aspectRatio.ratioEnum ==
//                                             _imageAspectRatio[index].ratioEnum
//                                         ? kSecondaryColor
//                                         : Colors.black,
//                                   ),
//                                 )),
//                           ))
//                 ],
//               ),
//               Expanded(
//                 child: Crop(
//                   image: widget.image,
//                   controller: _controller,
//                   aspectRatio: _aspectRatio.ratio,
//                   onCropped: (result) {
//                     loading = false;
//                     load();
//                     if (result is CropSuccess) {
//                       final croppedBytes = result.croppedImage;
//                       Navigator.pop(context, croppedBytes);
//                     } else {
//                       IfException.showMessage(
//                           message: "Error on cropping image");
//                     }
//                   },
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           LN.cancel,
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: kFontFMedium,
//                               color: Colors.black),
//                         )),
//                   ),
//                   Expanded(
//                     child: TextButton(
//                         onPressed: () {
//                           loading = true;
//                           load();
//                           _controller.crop();
//                         },
//                         child: Text(
//                           LN.ok,
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: kFontFMedium,
//                               color: Colors.black),
//                         )),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
