import 'package:latlong2/latlong.dart';

class StationService {
  final StationsDbMock _db = StationsDbMock();

  List<Station> getStations() {
    return _db.stationsList();
  }

  int getAvailableConnectorCount(Station station) {
    return station.connectors
        .where((connector) => connector.status == ConnectorStatus.avaliable)
        .length;
  }

  double getDistanceInMeters(LatLng currentPosition, Station station) {
    return Distance().as(LengthUnit.Meter, currentPosition, station.position);
  }

  Set<ConnectorType> getConnectorsType(String name){
    var station = _db.findStation(name);
    Set<ConnectorType> connectors = {};
    for (var connector in station.connectors){
      connectors.add(connector.type);
    }
    return connectors;
  }
}

class StationsDbMock {
  Map<String, Station> stations = {
    "Станция №1": Station("Станция №1", LatLng(56.4667, 84.9644), [
      Connector(ConnectorType.type2, 1, ConnectorStatus.avaliable),
    ]),
    "Станция №2": Station("Станция №2", LatLng(56.4721, 84.9522), [
      Connector(ConnectorType.type2, 2, ConnectorStatus.avaliable),
      Connector(ConnectorType.type2, 3, ConnectorStatus.avaliable),
    ]),
    "Станция №3": Station("Станция №3", LatLng(56.4581, 84.9599), [
      Connector(ConnectorType.type2, 4, ConnectorStatus.avaliable),
      Connector(ConnectorType.ccs1, 5, ConnectorStatus.occupied),
    ]),
    "Станция №4": Station("Станция №4", LatLng(56.4618, 84.9672), [
      Connector(ConnectorType.type2, 6, ConnectorStatus.avaliable),
      Connector(ConnectorType.ccs2, 7, ConnectorStatus.occupied),
      Connector(ConnectorType.ccs2, 8, ConnectorStatus.avaliable),
    ]),
    "Станция №5": Station("Станция №5", LatLng(56.4673, 84.9670), [
      Connector(ConnectorType.type2, 9, ConnectorStatus.avaliable),
    ]),
    "Станция №6": Station("Станция №6", LatLng(56.4884, 84.9797), [
      Connector(ConnectorType.type2, 10, ConnectorStatus.avaliable),
      Connector(ConnectorType.type2, 11, ConnectorStatus.avaliable),
      Connector(ConnectorType.type2, 12, ConnectorStatus.occupied),
      Connector(ConnectorType.type2, 13, ConnectorStatus.avaliable),
      Connector(ConnectorType.type2, 14, ConnectorStatus.occupied),
    ]),
    "Станция №7": Station("Станция №7", LatLng(56.4559, 84.9785), [
      Connector(ConnectorType.type2, 15, ConnectorStatus.avaliable),
      Connector(ConnectorType.ccs1, 16, ConnectorStatus.avaliable),
      Connector(ConnectorType.ccs2, 17, ConnectorStatus.occupied),
      Connector(ConnectorType.j1772, 18, ConnectorStatus.avaliable),
      Connector(ConnectorType.tesla, 19, ConnectorStatus.occupied),
    ]),
  };

  List<Station> stationsList() {
    return stations.values.toList();
  }

  Station findStation(String name){
    return stations[name]!;
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
  final Stopwatch _stopwatch = Stopwatch();
  int useTime = 2985;
  // int get useTime => _stopwatch.elapsed.inSeconds;

  void startCharge(){
    _stopwatch.start();
    status = ConnectorStatus.occupied;
  }

  void stopCharge(){
    _stopwatch.stop();
    status = ConnectorStatus.avaliable;
  }
}

enum ConnectorStatus { avaliable, occupied }

enum ConnectorType { type2, ccs1, ccs2, tesla, j1772 }
