import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/widgets/image/image_error.dart';

class ImageSlideShow extends StatefulWidget {
  final List<String> imageUrls;
  final Duration interval;

  const ImageSlideShow({
    super.key,
    required this.imageUrls,
    required this.interval,
  });

  @override
  _ImageSlideShowState createState() => _ImageSlideShowState();
}

class _ImageSlideShowState extends State<ImageSlideShow>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late Timer _timer;
  late AnimationController _controller;

  bool _showChildImage = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _startTimer();
    _startTransition();
  }

  @override
  void dispose() {
    _stopTimer();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.interval, (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.imageUrls.length;

        _controller.reset();
        _controller.forward();
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void _startTransition() {
    setState(() {
      _showChildImage = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showChildImage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 3),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: CachedNetworkImageProvider(widget.imageUrls[_currentIndex]),
            fit: BoxFit.contain,
            onError: (exception, stackTrace) =>
                ImageError.text(context, "", "")),
      ),
      child: FadeTransition(
        opacity: _controller,
        child: Center(
          child: AnimatedSwitcher(
            duration: Duration(seconds: 2),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.imageUrls[_currentIndex],
                  key: ValueKey(widget.imageUrls[_currentIndex]),
                  fit: BoxFit.contain,
                  colorBlendMode: BlendMode.dstATop,
                  placeholder: ImageError.load,
                  errorWidget: ImageError.text,
                ),
                AnimatedOpacity(
                  opacity: _showChildImage ? 0.5 : 0.0,
                  duration: Duration(seconds: 2),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[_currentIndex],
                    fit: BoxFit.cover,
                    placeholder: ImageError.load,
                    errorWidget: ImageError.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:math';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_account/ln.dart';

// class ImageSlideshow extends StatefulWidget {
//   final List<String> imageUrls;
//   final Duration duration;
//   final double initialScale;
//   final double finalScale;
//   final double initialOpacity;
//   final double finalOpacity;

//   const ImageSlideshow({
//     super.key,
//     required this.imageUrls,
//     this.duration = const Duration(seconds: 5),
//     this.initialScale = 0.8,
//     this.finalScale = 1.0,
//     this.initialOpacity = 0.0,
//     this.finalOpacity = 1.0,
//   }) ;

//   @override
//   _ImageSlideshowState createState() => _ImageSlideshowState();
// }

// class _ImageSlideshowState extends State<ImageSlideshow>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late Timer _timer;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: widget.duration,
//     );
//     _controller.forward();

//     _timer = Timer.periodic(widget.duration, (timer) {
//       setState(() {
//         _currentIndex = (_currentIndex + 1) % widget.imageUrls.length;
//       });
//       _controller.reset();
//       _controller.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _scale = [widget.finalScale, widget.initialScale];
//     final _scaleBegin = _scale[Random().nextInt(_scale.length)];
//     final _scaleEnd = _scaleBegin == widget.finalScale
//         ? widget.initialScale
//         : widget.finalScale;
//     final _scaleAnimation = Tween<double>(
//       begin: _scaleBegin,
//       end: _scaleEnd,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.linear,
//     ));

//     final _opa = [widget.initialOpacity, widget.finalOpacity];
//     final _opeBegin = _opa[Random().nextInt(_opa.length)];
//     final _opaEnd = _opeBegin == widget.initialOpacity
//         ? widget.finalOpacity
//         : widget.initialOpacity;
//     final _opacityAnimation = Tween<double>(
//       begin: _opeBegin,
//       end: _opaEnd,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.linear,
//     ));

//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Container(
//           color: Colors.black,
//           child: Center(
//             child: Stack(
//               children: [
//                 _buildImage(
//                   widget.imageUrls[_currentIndex],
//                   _scaleAnimation.value,
//                   _opacityAnimation.value,
//                 ),
//                 _buildImage(
//                   widget
//                       .imageUrls[(_currentIndex + 1) % widget.imageUrls.length],
//                   _scaleAnimation.value,
//                   1 - _opacityAnimation.value,
//                 ),
//                 _buildImage(
//                   widget
//                       .imageUrls[(_currentIndex + 2) % widget.imageUrls.length],
//                   _scaleAnimation.value,
//                   _opacityAnimation.value,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildImage(String imageUrl, double scale, double opacity) {
//     return Opacity(
//       opacity: opacity,
//       child: Transform.scale(
//           scale: scale,
//           child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               fit: BoxFit.cover,
//               // placeholder: (context, url) => placeHolder ?? Loading(),
//               errorWidget: (context, url, error) => Center(
//                     child: Text(
//                       LN.unsupportedImage,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontStyle: FontStyle.normal,
//                         color: Colors.white,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ))),
//     );
//   }
// }
