enum SerieModeType { one, onlyFuture, all }

extension EditModeTypeExtension on SerieModeType {
  String get name {
    switch (this) {
      case SerieModeType.one:
        return 'One';
      case SerieModeType.onlyFuture:
        return 'OnlyFuture';
      case SerieModeType.all:
        return 'All';
      default:
        throw Exception('$name is not a valid serie mode type.');
    }
  }
}
