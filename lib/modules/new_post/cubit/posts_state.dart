abstract class PostState {}

class PostInitial extends PostState {} // Initial state

class PostLoadingState extends PostState {} // State when a post-related action is loading

class PostSuccessState extends PostState {} // State when a post is successfully created or loaded

class PostErrorState extends PostState {
  final String error;
  PostErrorState(this.error);
}

// Image related states
class PostImagePickedSuccessState extends PostState {} // When an image is successfully picked

class PostImagePickedErrorState extends PostState {
  final String error;
  PostImagePickedErrorState(this.error);
}

class PostImageRemovedState extends PostState {} // When an image is removed

// Post deletion states
class PostDeleteSuccessState extends PostState {} // When a post is successfully deleted

class PostDeleteErrorState extends PostState {
  final String error;
  PostDeleteErrorState(this.error);
}

// Post like states (to toggle likes)
class PostLikedState extends PostState {} // When a post is liked
