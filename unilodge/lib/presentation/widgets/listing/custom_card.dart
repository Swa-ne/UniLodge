import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';


class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    required this.cardName,
    required this.description,
    required this.leading,
    this.leadingWidth = 40.0,
    this.leadingHeight = 40.0,
    this.iconSize = 22.0,
    this.isSelected = false, 
    required this.onTap, 
  });

  final String cardName;
  final String description;
  final Widget leading;
  final double leadingWidth;
  final double leadingHeight;
  final double iconSize;
  final bool isSelected;
  final VoidCallback onTap; 

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.93,
      upperBound: 1.0,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isSelected) {
      _animationController.reverse();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: () {
          if (!widget.isSelected) {
            _animationController.forward();
          }
        },
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: 350,
            height: 130,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF636464).withOpacity(0.15),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
                border: widget.isSelected
                    ? Border.all(color: Colors.black, width: 1.0)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: widget.leadingWidth,
                        height: widget.leadingHeight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: widget.leading,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.cardName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
