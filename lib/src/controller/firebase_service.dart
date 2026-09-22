import 'package:firebase_database/firebase_database.dart';
import 'package:solar_hatch_mobile/src/model/incubation_data.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Stream<IncubationData> get incubationDataStream {
    return _dbRef.child('test').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return IncubationData.fromJson(data);
      }
      return IncubationData.initial();
    });
  }
}
