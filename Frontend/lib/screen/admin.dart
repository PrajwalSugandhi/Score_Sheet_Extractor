import 'package:btp/controller/database.dart';
import 'package:btp/helper/dialog.dart';
import 'package:btp/widgets/admintile.dart';
import 'package:flutter/material.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Controls'),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 23),
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
              radius: 1.5,
            ),
          ),
          child: Column(
            children: [
              AdminTile(
                  title: 'Insert Data',
                  subtitle: 'Insert student data in database',
                  icon: Icons.person_add_alt_1_outlined,
                  onTap: () {
                    Messenger.showInsertDialog(context);
                  }),
              AdminTile(
                title: 'Get Data',
                subtitle: 'Get student data from database',
                icon: Icons.cloud_download_outlined,
                  onTap: () {
                    Messenger.showGetDialog(context);
                },
              ),
              AdminTile(
                title: 'Delete Data',
                subtitle: 'Delete student data from database',
                icon: Icons.delete,
                onTap: () {
                  Messenger.showDeleteDialog(context);
                },
              ),
            ],
          )),
    );
  }
}
