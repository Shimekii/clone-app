import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:evgo_clone/screens/session_summary_screen.dart';

class ChargeScreen extends StatefulWidget {
  final String stationName;
  final int connectorNumber;
  const ChargeScreen({
    super.key,
    required this.stationName,
    required this.connectorNumber,
  });

  @override
  State<ChargeScreen> createState() => _ChargeScreen();
}

class _ChargeScreen extends State<ChargeScreen> {
  double _sliderProgress = 0;

  Widget _buildBottomAction({
    required IconData? icon,
    required String label,
    required String? svgIconPath,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: 76,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon == null && svgIconPath != null) ...{
                SvgPicture.asset(svgIconPath, width: 30, height: 30),
              } else if (svgIconPath == null) ...{
                Icon(icon, size: 30),
              },
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, height: 1.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row columnLineText(String leftText, String rightText) {
    return Row(
      children: [
        Text(leftText, style: TextStyle(fontSize: 16)),
        Spacer(),
        Text(rightText, style: boldText(16)),
      ],
    );
  }

  TextStyle boldText(double size) {
    return TextStyle(fontSize: size, fontWeight: FontWeight.bold);
  }

  BoxDecoration boxStyle() {
    return BoxDecoration(
      color: Color(0xFFF3F7E9),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              Text(widget.stationName, style: boldText(22)),

              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: boxStyle(),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      widget.connectorNumber.toString(),
                      style: boldText(22),
                    ),
                  ),
                ),
              ),

              DecoratedBox(
                decoration: boxStyle(),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    spacing: 8,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/lightning-bolt.svg",
                        width: 26,
                        height: 26,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("0.00 kWh", style: boldText(18)),
                          Text("Energy", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Средняя мощность: 0.00 kW"),
                          Text("Пиковая мощность: -"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Image.asset("assets/images/charge_vehicle.jpg"),

              DecoratedBox(
                decoration: boxStyle(),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      columnLineText("Текущая мощность зарядки", "0.00 kW"),
                      columnLineText("Энергия", "0.00 kWh"),
                      columnLineText("Длительность", "0 сек."),
                      columnLineText("Количество", "-"),
                    ],
                  ),
                ),
              ),

              DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFB2DFF4),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    spacing: 8,
                    children: [
                      Icon(Icons.info, color: Color(0xFF0194DA), size: 24),
                      Expanded(
                        child: Text(
                          "После завершения зарядки, пожалуйста, переместите свой автомобиль,"
                          " чтобы дать возможность зарядить другие машины.",
                          style: boldText(12),
                        ),
                      ),
                      Icon(Icons.close, size: 24),
                    ],
                  ),
                ),
              ),

              // свайп
              Center(
                child: SizedBox(
                  width: 322,
                  height: 56,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const knobSize = 44.0;
                      const knobInset = 6.0;
                      final travelDistance =
                          constraints.maxWidth - knobSize - knobInset * 2;

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _sliderProgress =
                                (_sliderProgress +
                                        details.delta.dx / travelDistance)
                                    .clamp(0.0, 1.0);
                          });
                        },
                        onHorizontalDragEnd: (_) {
                          if (_sliderProgress >= 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SessionSummaryScreen(
                                  stationName: widget.stationName,
                                  connectorNumber: widget.connectorNumber,
                                ),
                              ),
                            );
                          } else {
                            setState(() => _sliderProgress = 0);
                          }
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFF3F7E9),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                "Проведите, чтобы завершить",
                                style: boldText(14),
                              ),
                              Positioned(
                                left:
                                    knobInset +
                                    travelDistance * _sliderProgress,
                                child: Container(
                                  width: knobSize,
                                  height: knobSize,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFF3F7E9),
        child: SafeArea(
          left: false,
          right: false,
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                _buildBottomAction(
                  icon: Icons.add_location_alt_outlined,
                  label: 'Найти заправку',
                  svgIconPath: null,
                ),
                _buildBottomAction(
                  icon: null,
                  label: 'Зарядка...',
                  svgIconPath: "assets/icons/charging-station.svg",
                ),
                _buildBottomAction(
                  icon: Icons.info_outline,
                  label: 'Помощь',
                  svgIconPath: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
