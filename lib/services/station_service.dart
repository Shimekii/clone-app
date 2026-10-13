import 'package:latlong2/latlong.dart';

class StationService {
  final StationsDbMock _db = StationsDbMock();

  List<Station> getStations() {
    return _db.stationsInDataBase();
  }

  int getAvailableConnectorCount(Station station) {
    return station.connectors
        .where((connector) => connector.status == ConnectorStatus.avaliable)
        .length;
  }

  double getDistanceInMeters(LatLng currentPosition, Station station) {
    return Distance().as(LengthUnit.Meter, currentPosition, station.position);
  }
}

class StationsDbMock {
  List<Station> stations = [
    Station("Станция №1", LatLng(56.4667, 84.9644), [
      Connector(ConnectorType.type2, 1, ConnectorStatus.avaliable),
    ]),
    Station("Станция №2", LatLng(56.4721, 84.9522), [
      Connector(ConnectorType.type2, 2, ConnectorStatus.avaliable),
      Connector(ConnectorType.type2, 3, ConnectorStatus.avaliable),
    ]),
    Station("Станция №3", LatLng(56.4581, 84.9599), [
      Connector(ConnectorType.type2, 4, ConnectorStatus.avaliable),
      Connector(ConnectorType.ccs1, 5, ConnectorStatus.occupied),
    ]),
    Station("Станция №4", LatLng(56.4618, 84.9672), [
      Connector(ConnectorType.ccs2, 6, ConnectorStatus.avaliable),
    ]),
    Station("Станция №5", LatLng(56.4673, 84.9670), [
      Connector(ConnectorType.type2, 7, ConnectorStatus.avaliable),
    ]),
  ];

  List<Station> stationsInDataBase() {
    return stations;
  }
}

class Station {
  final String name;
  final LatLng position;
  final List<Connector> connectors;

  Station(this.name, this.position, this.connectors);
}

class Connector {
  final ConnectorType type;
  final int number;
  ConnectorStatus status;
  Connector(this.type, this.number, this.status);
}

enum ConnectorStatus { avaliable, occupied }

enum ConnectorType { type2, ccs1, ccs2, tesla, j1772 }
