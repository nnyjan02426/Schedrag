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
  final Map<String, List<_Block>> categories = {};

  void addBlock() {}
  void removeBlock() {}

  // TODO: create file storing api
  void write2Json() {}
}
