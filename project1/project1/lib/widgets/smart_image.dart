import 'package:flutter/material.dart';

class SmartImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SmartImage({super.key, this.imageUrl, this.width, this.height, this.fit = BoxFit.cover, this.borderRadius});

  bool get _isNetworkImage =>
      imageUrl?.startsWith('http://') == true || imageUrl?.startsWith('https://') == true;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    final Widget imageWidget =
        _isNetworkImage
            ? Image.network(
              imageUrl!,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (_, __, ___) => _buildErrorWidget(),
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildLoadingIndicator();
              },
            )
            : Image.asset(
              imageUrl!.startsWith('assets/') ? imageUrl! : 'assets/ServTech.png',
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (_, __, ___) => _buildErrorWidget(),
            );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius),
      child: const Center(child: Icon(Icons.image, color: Color(0xff184c6b), size: 24)),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius),
      child: const Center(child: Icon(Icons.broken_image, color: Color(0xff184c6b), size: 24)),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius),
      child: const Center(child: CircularProgressIndicator(color: Color(0xffc29424), strokeWidth: 2)),
    );
  }
}
