class _Time {
  DateTime startTime, endTime;
  late Duration diffTime;
  _Time(this.startTime, this.endTime, this.diffTime);
  _Time.noParams()
      : startTime = DateTime.now(),
        endTime = DateTime.now() {
    updateDiffTime();
  }

  void setStartTime(DateTime newStart) => startTime = newStart;
  void setEndTime(DateTime newEnd) => endTime = newEnd;
  void updateDiffTime() => diffTime = startTime.difference(endTime);
}

class _Block {
  String name;
  String? category, notes;
  _Time time;

  _Block(this.name, this.time);
}

class Blocks {
  final Map<String, dynamic> categories = {};

  void addBlock() {}
  void removeBlock() {}

  // TODO: create file storing api
  // NOTE: https://stackoverflow.com/questions/51807228/writing-to-a-local-json-file-dart-flutter
  void write2file() {}
}
