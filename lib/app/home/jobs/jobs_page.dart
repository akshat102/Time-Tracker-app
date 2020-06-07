import 'package:first/app/home/job_entries/job_entries_page.dart';
import 'package:first/app/home/jobs/edit_job_page.dart';
import 'package:first/app/home/jobs/job_list_tile.dart';
import 'package:first/app/home/jobs/list_item_builder.dart';
import 'package:first/app/home/models/job.dart';
import 'package:first/common_widgets/platform_exception_alert_dialog.dart';
import 'package:first/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:first/common_widgets/platform_alert_dialog.dart';
import 'package:first/services/auth.dart';

class JobsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => EditJobPage.show(context,
                  database: Provider.of<Database>(context),
              ),
          ),
        ],
      ),
      body: _buildContents(context),
      );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) =>
              Dismissible(
                key: Key('job-${job.id}'),
                background: Container(color: Colors.red,),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _delete(context, job),
                child: JobListTile(
                  job: job,
                  onTap: () {
                    JobEntriesPage.show(
                        context,
                        job);
                  }
                ),
              ),
        );
      });
  }

  Future<void> _delete(BuildContext context, Job job) async {
   try{
     final database = Provider.of<Database>(context);
     await database.deleteJob(job);
   } on PlatformException catch(e){
     PlatformExceptionAlertDialog(
         title: 'Operation failed',
         exception: e).show(context);
   }
  }
}
