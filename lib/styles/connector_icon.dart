import 'package:evgo_clone/services/station_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

extension ConnectorTypeExtension on ConnectorType {
  String get assetPath {
    switch (this) {
      case ConnectorType.type2:
        return 'assets/icons/ev-plug-type2.svg';
      case ConnectorType.ccs1:
        return 'assets/icons/ev-plug-ccs1.svg';
      case ConnectorType.ccs2:
        return 'assets/icons/ev-plug-ccs2.svg';
      case ConnectorType.tesla:
        return 'assets/icons/ev-plug-tesla.svg';
      case ConnectorType.j1772:
        return 'assets/icons/ev-plug-j1772.svg';
    }
  }

  String get name {
    switch(this) {
      case ConnectorType.type2:
        return 'Type 2';
      case ConnectorType.ccs1:
        return 'CCS1';
      case ConnectorType.ccs2:
        return 'CCS2';
      case ConnectorType.tesla:
        return 'Tesla';
      case ConnectorType.j1772:
        return 'J1772';
    }
  }
}

class ConnectorIcon extends StatelessWidget {
  final ConnectorType type;
  final double size;

  const ConnectorIcon({
    super.key,
    required this.type,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      type.assetPath,
      width: size,
      height: size,
    );
  }
}