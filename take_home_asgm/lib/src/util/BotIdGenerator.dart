// ignore_for_file: file_names
class BotIdGenerator {
  int _currentId = 0;

  int generateId() {
    _currentId += 1;
    return _currentId;
  }
}
