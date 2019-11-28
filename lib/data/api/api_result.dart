class ApiResult<T> {
  final bool success;
  final T data;
  final String message;

  ApiResult.success(T data)
      : this.data = data,
        this.message = null,
        this.success = true;

  ApiResult.failure(String message)
      : this.data = null,
        this.message = message,
        this.success = false;
}
