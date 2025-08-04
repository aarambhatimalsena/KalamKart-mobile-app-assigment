abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

class RemoteDatabaseFailure extends Failure {
  RemoteDatabaseFailure(super.message);
}
class SharedPreferencesFailure extends Failure {
  SharedPreferencesFailure(super.message);
}
