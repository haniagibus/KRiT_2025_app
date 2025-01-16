class Event {
  final String name;
  final String logoUrl;
  final String coverImageUrl;
  final String timeBegin;
  final String timeEnd;
  final DateTime date;
  final String description;


  Event(this.name, this.logoUrl, this.coverImageUrl, this.timeBegin, this.timeEnd,
      this.date, this.description);

  Event.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        logoUrl = json['logo'],
        coverImageUrl = json['cover'],
        timeBegin = json['begin'],
        timeEnd = json['end'],
        date = DateTime.parse(json['date']),
        description = json['description'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'logo': logoUrl,
    'cover': coverImageUrl,
    'begin': timeBegin,
    'end': timeEnd,
    'date': date.toIso8601String(),
    'description': description
  };
}



class MockPartner extends Event {
  MockPartner(int id,String title, DateTime date)
      : super(
      title,
      "https://picsum.photos/500/500?$id",
      "https://picsum.photos/1000/300?$id",
      "10:00",
      "11:00",
      date,
      "mock event description");
}




