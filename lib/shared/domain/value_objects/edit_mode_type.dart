enum EditModeType { one, onlyFuture, all }

extension EditModeTypeExtension on EditModeType {
  String get name {
    switch (this) {
      case EditModeType.one:
        return 'One';
      case EditModeType.onlyFuture:
        return 'OnlyFuture';
      case EditModeType.all:
        return 'All';
      default:
        throw Exception('$name is not a valid edit mode type.');
    }
  }
}
