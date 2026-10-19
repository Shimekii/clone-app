import 'package:evgo_clone/screens/charge_screen.dart';
import 'package:evgo_clone/services/station_service.dart';
import 'package:evgo_clone/styles/connector_icon.dart';
import 'package:evgo_clone/styles/styles.dart';
import 'package:flutter/material.dart';

class StartSessionScreen extends StatefulWidget {
  final String stationName;
  final Connector connector;
  const StartSessionScreen({
    super.key, 
    required this.stationName,
    required this.connector
  });

  @override
  State<StartSessionScreen> createState() => _StartSessionScreen();
}

class _StartSessionScreen extends State<StartSessionScreen> {

  @override
  Widget build(BuildContext context) {
    final connectorNumber = widget.connector.number.toString();
    final stationName = widget.stationName;
    final connector = widget.connector;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      "Начало сессии",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              Text(stationName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.left),

              SizedBox(height: 16),

              DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFF3F7E9),
                  borderRadius: BorderRadius.circular(5.0)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 14,
                    children: [
                      Row(
                        children: [
                          Text(connectorNumber, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.star_border_rounded, size: 36),
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        spacing: 6,
                        children: [
                          ConnectorIcon(type: connector.type),
                          Text(connector.type.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),

                      if (connector.status == ConnectorStatus.occupied)...{
                        Text(renderLabel(connector.useTime), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                      }
                    ],
                    
                  ),
                )
              ),

              SizedBox(height: 12),

              if (connector.status == ConnectorStatus.occupied)...{
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE8C6),
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.warning_rounded, color: Color(0xFFFFB23D)),
                        Text("Занято другим пользователем", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                      ],
                    ),
                  )
                ),
                SizedBox(height: 12)
              },

              SizedBox(
                height: 40,
                width: double.infinity,
                child: greenButton(text: "Начать зарядку",
                icon: Icons.power_settings_new_rounded,
                onPressed: () {
                  if (connector.status == ConnectorStatus.avaliable) {
                    connector.startCharge();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChargeScreen(stationName: stationName, connectorNumber: connector.number))
                    );
                  }
                },
                isActive: connector.status == ConnectorStatus.avaliable ? true : false
              ),
            )


            ],
          ),
        )
      ),
    );
  }
}