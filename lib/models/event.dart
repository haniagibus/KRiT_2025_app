class Event {
  final String name;
  final String logoUrl;
  final String coverImageUrl;
  final String timeBegin;
  final String timeEnd;
  final String description;

  Event(this.name, this.logoUrl, this.coverImageUrl, this.timeBegin, this.timeEnd,
      this.description);

  Event.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        logoUrl = json['logo'],
        coverImageUrl = json['cover'],
        timeBegin = json['begin'],
        timeEnd = json['end'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'logo': logoUrl,
    'cover': coverImageUrl,
    'begin': timeBegin,
    'end': timeEnd,
    'description': description
  };
}

class MockPartner extends Event {
  MockPartner(int id)
      : super(
      "mock event",
      "https://picsum.photos/500/500?$id",
      "https://picsum.photos/1000/300?$id",
      "10:00",
      "11:00",
      "mock event description");
}