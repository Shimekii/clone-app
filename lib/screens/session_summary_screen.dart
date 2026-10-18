import 'package:flutter/material.dart';

class SessionSummaryScreen extends StatefulWidget {
  final String stationName;
  final int connectorNumber;
  const SessionSummaryScreen({
    super.key,
    required this.stationName,
    required this.connectorNumber,
  });

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreen();
}

class _SessionSummaryScreen extends State<SessionSummaryScreen> {

  String _dateLabel(){
    final now = DateTime.now();
    final minute = now.minute.toString();
    final hour = now.hour.toString();
    final day = now.day.toString();
    final month = now.month.toString();
    final year = now.year.toString();
    return "$hour:$minute $day/$month/$year";
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

  DecoratedBox infoLabel(String text){
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFB2DFF4),
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          spacing: 8,
          children: [
            Icon(Icons.info, color: Colors.blue),
            Expanded(
              child: Text(text, style: boldText(14)),
            )
          ],
        ),
      )
    );
  }


  BoxDecoration boxStyle() {
    return BoxDecoration(
      color: Color(0xFFF3F7E9),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  Widget _buildBottomAction({required IconData icon, required String label}) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: 76,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30),
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
            spacing: 12,
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      );
                    },
                    icon: Icon(Icons.arrow_back, size: 24),
                  ),
                  Text("Сводка по сессии", style: boldText(24))
                ],
              ),

              Text(widget.stationName, style:boldText(22)),

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
                    child: Column(
                    children: [
                      columnLineText("Энергия", "0.00 kWh"),
                      columnLineText("Среднее", "0.00 kW"),
                      columnLineText("Максимум", "-")
                    ],
                  ),
                )
              ),

              infoLabel("Беслатная зарядка"),
              infoLabel("Кривая зарядки не доступна для этой сессии"),

              DecoratedBox(
                decoration: boxStyle(),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      columnLineText("Начало", _dateLabel()),
                      columnLineText("Длительность сессии", "0 сек."),
                      columnLineText("Ожидание", "0 сек.")
                    ],
                  ),
                ),
              ),
            ],
          )
        )
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xFFF3F7E9)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            _buildBottomAction(
              icon: Icons.add_location_alt_outlined,
              label: 'Найти заправку',
            ),
            _buildBottomAction(
              icon: Icons.qr_code_scanner,
              label: 'Сканировать QR',
            ),
            _buildBottomAction(icon: Icons.info_outline, label: 'Помощь'),
          ],
        ),
      ),
    );
  }
}