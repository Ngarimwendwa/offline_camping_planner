import 'package:flutter/material.dart';
import 'models/database_helper.dart';
import 'models/camping_site.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Camping Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _databaseHelper = DatabaseHelper.instance;
  final _campingSiteNameController = TextEditingController();
  final _campingSiteLocationController = TextEditingController();
  final _campingSiteDescriptionController = TextEditingController();
  late List<CampingSite> _campingSites;

  @override
  void initState() {
    super.initState();
    _loadCampingSites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camping Planner'),
      ),
      body: _campingSites.isEmpty
          ? Center(
              child: Text('No camping sites yet.'),
            )
          : ListView.builder(
              itemCount: _campingSites.length,
              itemBuilder: (context, index) {
                final campingSite = _campingSites[index];
                return ListTile(
                  title: Text(campingSite.name),
                  subtitle: Text(campingSite.location),
                  onTap: () {
                    // Navigate to the details page
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add a new camping site'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _campingSiteNameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: _campingSiteLocationController,
                      decoration: InputDecoration(hintText: 'Location'),
                    ),
                    TextField(
                      controller: _campingSiteDescriptionController,
                      decoration: InputDecoration(hintText: 'Description'),
                      maxLines: null,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final newCampingSite = CampingSite(
                        name: _campingSiteNameController.text,
                        location: _campingSiteLocationController.text,
                        description: _campingSiteDescriptionController.text, 
                        
                      );

                      _databaseHelper.insertCampingSite(newCampingSite).then((value) {
                        setState(() {
                          _campingSites.add(newCampingSite);
                        });
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Null get newMethod => null;

  void _loadCampingSites() async {
    _campingSites = await _databaseHelper.getAllCampingSites();
    setState(() {});
  }
}