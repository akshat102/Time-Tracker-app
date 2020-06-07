import 'package:meta/meta.dart';

class Job{
  final String id;
  final String name;
  final double ratePerHour;
  Job({@required this.id, @required this.name, @required this.ratePerHour});
factory Job.fromMap(Map<String, dynamic> data,String documentId){
  if(data == null){
    return null;
  }
  final String name = data['name'];
  final double ratePerHour =data['ratePerHour'];
  return Job(
    id: documentId,
    name: name,
    ratePerHour: ratePerHour,
  );
}
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}