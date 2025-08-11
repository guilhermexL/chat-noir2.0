import 'package:flutter/material.dart';
import '../models/position.dart';
import '../models/game_state.dart';
import '../services/theme_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HexCell extends StatefulWidget {
  final Position position;
  final CellType cellType;
  final bool isSelected;
  final VoidCallback onTap;

  const HexCell({
    super.key,
    required this.position,
    required this.cellType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<HexCell> createState() => _HexCellState();
}

class _HexCellState extends State<HexCell> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap();
  }

  Color _getBackgroundColor() {
    if (widget.isSelected) {
      return ThemeService.getCellColor(context, true);
    }

    switch (widget.cellType) {
      case CellType.cat:
        return Colors.yellow.shade300;
      case CellType.fence:
        return Colors.grey.shade900;
      case CellType.empty:
        return ThemeService.getCellColor(context, false);
    }
  }

  Color _getBorderColor() {
    if (widget.isSelected) {
      return ThemeService.getBorderColor(context);
    }

    switch (widget.cellType) {
      case CellType.cat:
        return Colors.yellow.shade700;
      case CellType.fence:
        return Colors.grey.shade700;
      case CellType.empty:
        return ThemeService.getBorderColor(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final borderColor = _getBorderColor();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(
                  color: borderColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: _buildCellContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCellContent() {
    switch (widget.cellType) {
      case CellType.cat:
        return Center(
          child: SvgPicture.asset(
            'assets/images/cat.svg',
            width: 20,
            height: 20,
          ),
        );
      case CellType.fence:
        return Center(
          child: SvgPicture.asset(
            'assets/images/fence.svg',
            width: 20,
            height: 20,
          ),
        );
      case CellType.empty:
        return const SizedBox.shrink();
    }
  }
}
