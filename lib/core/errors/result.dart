class Result<T> {
  final T? data;
  final Object? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;

  T getOrThrow() {
    if (error != null) {
      throw error!;
    }

    return data as T;
  }
}
