sealed class ContentState {
  const ContentState();

  bool get isInitial => this is ContentStateInitial;
  bool get isLoading => this is ContentStateLoading;
  bool get isSuccess => this is ContentStateSuccess;
  bool get isError => this is ContentStateError;
}

class ContentStateInitial extends ContentState {
  const ContentStateInitial();
}

class ContentStateLoading extends ContentState {
  const ContentStateLoading();
}

class ContentStateSuccess extends ContentState {
  const ContentStateSuccess();
}

class ContentStateError extends ContentState {
  final String message;
  const ContentStateError(this.message);
}
