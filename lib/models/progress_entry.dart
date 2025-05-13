class ProgressEntry {
  final double weight;
  final DateTime date;

  ProgressEntry({required this.weight, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'date': date.toIso8601String(),
    };
  }

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    return ProgressEntry(
      weight: json['weight'],
      date: DateTime.parse(json['date']),
    );
  }
}
