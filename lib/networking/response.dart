class ResponseStatus<T> {
  late Status status;
  late T data;
  late String message;

  ResponseStatus.loading(this.message) : status = Status.LOADING;
  ResponseStatus.completed(this.data) : status = Status.COMPLETED;
  ResponseStatus.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
