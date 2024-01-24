class CampingSite {
 final int id;
 final String name;
 final String location;
 final String description;

 CampingSite({required this.id, required this.name, required this.location, required this.description});

 Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
    };
 }

 factory CampingSite.fromMap(Map<String, dynamic> map) {
    return CampingSite(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      description: map['description'],
    );
 }

 static const table = 'camping_sites';
 static const columnId = 'id';
 static const columnName = 'name';
 static const columnLocation = 'location';
 static const columnDescription = 'description';
}
