import 'package:flutter/material.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.flex,
    required this.widthFactor,
  });

  final int flex;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ));
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(flex: 6, widthFactor: 1),
          SizedBox(height: 10.0),
          ShimmerBox(flex: 1, widthFactor: 1),
          SizedBox(height: 10),
          ShimmerBox(flex: 1, widthFactor: .75),
          SizedBox(height: 20),
          ShimmerBox(flex: 6, widthFactor: 1),
          SizedBox(height: 10.0),
          ShimmerBox(flex: 1, widthFactor: 1),
          SizedBox(height: 10),
          ShimmerBox(flex: 1, widthFactor: .75),
          SizedBox(height: 20),
          ShimmerBox(flex: 3, widthFactor: 1),
          SizedBox(height: 10.0),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
