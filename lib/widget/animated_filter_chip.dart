import 'package:flutter/material.dart';

class AnimatedFilterChip extends StatefulWidget {
  final Function() onTap;

  final Function<String>() title;

  final bool initialSelected;

  const AnimatedFilterChip(
      {super.key,
      required this.onTap,
      required this.title,
      required this.initialSelected});

  @override
  State<StatefulWidget> createState() {
    return AnimatedFilterChipState(onTap, title, initialSelected);
  }
}

class AnimatedFilterChipState extends State<AnimatedFilterChip>
    with TickerProviderStateMixin {
  static const int _animationDuration = 300;

  static const double _textLeftPaddingStart = 40.0;

  static const double _textLeftPaddingEnd = 20.0;

  static const double _textRightPaddingStart = 20.0;

  static const double _textRightPaddingEnd = 40.0;

  static const double _dotHeightStart = 20.0;

  static const double _dotHeightEnd = 40.0;

  static const double _dotLeftStart = 10.0;

  static const double _dotLeftEnd = 0.0;

  static const double _dotTopStart = 8.5;

  static const double _dotTopEnd = -1.0;

  final Function() _onTap;

  final Function<String>() _title;

  final bool _initialSelected;

  final GlobalKey _parentContainer = GlobalKey(debugLabel: 'parent container');

  bool _animationStateForward = true;

  late AnimationController _controller;

  late Animation<double> _dotWidthAnimation;

  AnimatedFilterChipState(this._onTap, this._title, this._initialSelected);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: _animationDuration));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _getDotWidthAnim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (_, Widget? widget) {
          return InkResponse(
            onTap: () {
              _onTap();
              if (_animationStateForward) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
              _animationStateForward = !_animationStateForward;
            },
            child: Container(
              key: _parentContainer,
              height: 40.0,
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
                border: Border.all(color: Colors.black26, width: 1.0),
              ),
              child: Stack(
                children: <Widget>[
                  _getFilterItemDot(),
                  _getFilterTitle(_title()),
                  _getCloseIcon()
                ],
              ),
            ),
          );
        });
  }

  Widget _getFilterTitle(String title) {
    return Align(
      widthFactor: 1.0,
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.only(
            left: _getTextLeftPaddingAnimation(_controller).value,
            right: _getTextRightPaddingAnimation(_controller).value),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: _getTextColorAnimation(_controller).value)),
      ),
    );
  }

  Animation<double> _getTextLeftPaddingAnimation(
      AnimationController controller) {
    if (_initialSelected) {
      return Tween<double>(
              begin: _textLeftPaddingEnd, end: _textLeftPaddingStart)
          .animate(controller);
    } else {
      return Tween<double>(
              begin: _textLeftPaddingStart, end: _textLeftPaddingEnd)
          .animate(controller);
    }
  }

  Animation<double> _getTextRightPaddingAnimation(
      AnimationController controller) {
    if (_initialSelected) {
      return Tween<double>(
              begin: _textRightPaddingEnd, end: _textRightPaddingStart)
          .animate(controller);
    } else {
      return Tween<double>(
              begin: _textRightPaddingStart, end: _textRightPaddingEnd)
          .animate(controller);
    }
  }

  Animation<Color?> _getTextColorAnimation(AnimationController controller) {
    if (_initialSelected) {
      return ColorTween(begin: Colors.white, end: Colors.black)
          .animate(controller);
    } else {
      return ColorTween(begin: Colors.black, end: Colors.white)
          .animate(controller);
    }
  }

  Widget _getFilterItemDot() {
    return Positioned(
      left: _getDotLeftAnimation(_controller).value,
      top: _getDotTopAnimation(_controller).value,
      child: Container(
        height: _getDotHeightAnimation(_controller).value,
        width: _getDotWidthAnim().value,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Animation<double> _getDotWidthAnim() {
    double width =
        (_parentContainer.currentContext?.findRenderObject() as RenderBox?)
                ?.paintBounds
                .width ??
            20.0;
    _dotWidthAnimation = _initialSelected
        ? Tween<double>(begin: width - 10, end: 20.0).animate(_controller)
        : Tween<double>(begin: 20.0, end: width - 10).animate(_controller);
    return _dotWidthAnimation;
  }

  Animation<double> _getDotHeightAnimation(AnimationController controller) {
    return _initialSelected
        ? Tween<double>(begin: _dotHeightEnd, end: _dotHeightStart)
            .animate(controller)
        : Tween<double>(begin: _dotHeightStart, end: _dotHeightEnd)
            .animate(controller);
  }

  Animation<double> _getDotLeftAnimation(AnimationController controller) {
    return _initialSelected
        ? Tween<double>(begin: _dotLeftEnd, end: _dotLeftStart)
            .animate(controller)
        : Tween<double>(begin: _dotLeftStart, end: _dotLeftEnd)
            .animate(controller);
  }

  Animation<double> _getDotTopAnimation(AnimationController controller) {
    return _initialSelected
        ? Tween<double>(begin: _dotTopEnd, end: _dotTopStart)
            .animate(controller)
        : Tween<double>(begin: _dotTopStart, end: _dotTopEnd)
            .animate(controller);
  }

  Widget _getCloseIcon() {
    Animation<double> scaleAnim =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    if (_initialSelected) {
      scaleAnim = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    }

    return Positioned(
        right: 5.0,
        top: 7.0,
        child: ScaleTransition(
            scale: scaleAnim,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade400),
              child: const Icon(
                Icons.close,
                size: 20.0,
                color: Colors.white,
              ),
            )));
  }
}
