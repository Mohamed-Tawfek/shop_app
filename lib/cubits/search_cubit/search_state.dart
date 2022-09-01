abstract class SearchState {}

class SearchInitial extends SearchState {}

class GetSearchDataLoading extends SearchState {}

class GetSearchDataSuccess extends SearchState {}

class GetSearchDataError extends SearchState {}
class ChangeIconCartStateLoading extends SearchState {}
class ChangeIconCartSuccess extends SearchState {}

class FailedChangeIconCartState extends SearchState {}
class LoadingChangeIconFavorite extends SearchState {}
class FailedChangeFavorite extends SearchState {}
class SuccessChangeFavorite extends SearchState {}
