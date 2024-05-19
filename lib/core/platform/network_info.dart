abstract class NetworkInfo {
  Future<bool> get isRemoteApproved;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(bool isRemoteApproved);

  @override
  Future<bool> get isRemoteApproved => isRemoteApproved;
}
