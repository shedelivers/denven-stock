

import "package:denvin_stock/exports.dart";


class FullScreenWidget extends StatelessWidget {
  FullScreenWidget({required this.child, required this.isOpen, this.backgroundColor = Colors.black, this.backgroundIsTransparent = true, required this.disposeLevel});

  final Widget child;
  final Color backgroundColor;
  final ValueChanged<bool> isOpen;
  final bool backgroundIsTransparent;
  final DisposeLevel disposeLevel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isOpen!(true);
        Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                barrierColor: backgroundIsTransparent ? Colors.white.withOpacity(0) : backgroundColor,
                pageBuilder: (BuildContext context, _, __) {
                  return FullScreenPage(
                    child: child,
                    backgroundColor: backgroundColor,
                    backgroundIsTransparent: backgroundIsTransparent,
                    disposeLevel: disposeLevel,
                    isOpen: isOpen,
                  );
                }));
      },
      child: child,
    );
  }
}

enum DisposeLevel { High, Medium, Low }

class FullScreenPage extends StatefulWidget {
  FullScreenPage(
      {required this.child,
      this.backgroundColor = Colors.black,
      this.backgroundIsTransparent = true,
      required this.isOpen,
      this.disposeLevel = DisposeLevel.Medium});

  final Widget child;
  final ValueChanged<bool> isOpen;
  final Color backgroundColor;
  final bool backgroundIsTransparent;
  final DisposeLevel disposeLevel;

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  double initialPositionY = 0;

  double currentPositionY = 0;

  double positionYDelta = 0;

  double opacity = 1;

  double disposeLimit = 150;

  late Duration animationDuration;

  @override
  void initState() {
    super.initState();
    setDisposeLevel();
    animationDuration = Duration.zero;
  }

  setDisposeLevel() {
    setState(() {
      if (widget.disposeLevel == DisposeLevel.High)
        disposeLimit = 300;
      else if (widget.disposeLevel == DisposeLevel.Medium)
        disposeLimit = 200;
      else
        disposeLimit = 100;
    });
  }

  void _startVerticalDrag(details) {
    setState(() {
      initialPositionY = details.globalPosition.dy;
    });
  }

  void _whileVerticalDrag(details) {
    print("dfaskljdsdsdds");
    setState(() {
      currentPositionY = details.globalPosition.dy;
      positionYDelta = currentPositionY - initialPositionY;
      setOpacity();
    });
  }

  setOpacity() {
    double tmp = positionYDelta < 0
        ? 1 - ((positionYDelta / 1000) * -1)
        : 1 - (positionYDelta / 1000);
    print(tmp);

    if (tmp > 1)
      opacity = 1;
    else if (tmp < 0)
      opacity = 0;
    else
      opacity = tmp;

    if (positionYDelta > disposeLimit || positionYDelta < -disposeLimit) {
      opacity = 0.5;
    }
  }

  _endVerticalDrag(DragEndDetails details) {
    print("dfaskljd");
    if (positionYDelta > disposeLimit || positionYDelta < -disposeLimit) {
      widget.isOpen(false);
      Navigator.of(context).pop();
    } else {
      setState(() {
        animationDuration = Duration(milliseconds: 300);
        opacity = 1;
        positionYDelta = 0;
      });

      Future.delayed(animationDuration).then((_) {
        setState(() {
          animationDuration = Duration.zero;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 50,horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: GestureDetector(
          onVerticalDragStart: (details) => _startVerticalDrag(details),
          onVerticalDragUpdate: (details) => _whileVerticalDrag(details),
          onVerticalDragEnd: (details) => _endVerticalDrag(details),
          behavior: HitTestBehavior.translucent,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(14)
            ),
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: animationDuration,
                  curve: Curves.fastOutSlowIn,
                  top: 0 + positionYDelta,
                  bottom: 0 - positionYDelta,
                  left: 0,
                  right: 0,
                  child: widget.child,
                ),
                Positioned(
                  right: 4,
                  child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.isOpen(false);
                  },
                  child: Container(
                    height: 34,
                    width: 34,
                    margin: const EdgeInsets.only(top: 10,right: 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                      child:Icon(Icons.close,size: 18,),
                    ),
                  ),
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//  @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 60,horizontal: 30),
//       child: Scaffold(
//         backgroundColor: widget.backgroundIsTransparent
//             ? Colors.transparent
//             : widget.backgroundColor,
//         body: GestureDetector(
//           onVerticalDragStart: (details) => _startVerticalDrag(details),
//           onVerticalDragUpdate: (details) => _whileVerticalDrag(details),
//           onVerticalDragEnd: (details) => _endVerticalDrag(details),
//           child: Container(
//             color: widget.backgroundColor.withOpacity(opacity),
//             constraints: BoxConstraints.expand(
//               height: MediaQuery.of(context).size.height,
//             ),
//             child: Stack(
//               children: <Widget>[
//                 AnimatedPositioned(
//                   duration: animationDuration,
//                   curve: Curves.fastOutSlowIn,
//                   top: 0 + positionYDelta,
//                   bottom: 0 - positionYDelta,
//                   left: 0,
//                   right: 0,
//                   child: widget.child,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }