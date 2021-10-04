import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    this.showElevation = true,
    this.containerHeight = 56,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    required this.currentTab,
    this.animationDuration = const Duration(milliseconds: 270),
    this.itemCornerRadius = 24,
    required this.curve,
  }) : super(key: key);

  final bool showElevation;
  final double containerHeight;
  final MainAxisAlignment mainAxisAlignment;
  final List<BottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final int currentTab;
  final Duration animationDuration;
  final double itemCornerRadius;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        if (showElevation)
          BoxShadow(
              color:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
              blurRadius: 2)
      ]),
      child: SafeArea(
        // необходим, т.к. на ифонах может быть отступ(10+ нижняя полоска)
        child: Container(
          // width: double.infinity, // растягиваем на ширину всего экрана
          height: containerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: items.map<Widget>((item) {
              var index = items.indexOf(item);

              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: _ItemWidget(
                  curve: curve,
                  animationDuration: animationDuration,
                  backGroundColor: Theme.of(context).backgroundColor,
                  isSelected: currentTab == index,
                  item: item,
                  itemCornerRaduis: itemCornerRadius,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.isSelected,
    required this.backGroundColor,
    required this.animationDuration,
    this.curve = Curves.linear,
    required this.item,
    required this.itemCornerRaduis,
  });

  final bool isSelected;
  final BottomNavBarItem item;
  final Color backGroundColor;
  final Duration animationDuration;
  final Curve curve;
  final double itemCornerRaduis;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // 8*4 - paddings, 4*2- промежуточное состояние между ними
      width: isSelected
          ? 150
          : (MediaQuery.of(context).size.width - 150 - 8 * 4 - 4 * 2) / 2,
      height: 30,
      curve: curve,
      decoration: BoxDecoration(
        color: isSelected
            ? item.activeColor.withOpacity(0.2)
            : Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(itemCornerRaduis),
      ),
      child: Row(
        children: <Widget>[
          Icon(item.asset,
              size: 20,
              color: isSelected ? item.activeColor : item.inactiveColor),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DefaultTextStyle.merge(
                child: item.title,
                textAlign: item.textAlign,
                maxLines: 1,
                style: TextStyle(
                  color: isSelected ? item.activeColor : item.inactiveColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBarItem {
  BottomNavBarItem(
      {required this.asset,
      required this.title,
      required this.activeColor,
      required this.inactiveColor,
      required this.textAlign});

  final IconData asset;
  final Text title;
  final Color activeColor;
  final Color inactiveColor;
  final TextAlign textAlign;
}
