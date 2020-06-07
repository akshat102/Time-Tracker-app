import 'package:first/app/home/models/job.dart';
import 'package:flutter/material.dart';

class JobListTile extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  const JobListTile({Key key, @required this.job, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
