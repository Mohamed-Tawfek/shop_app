abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class GetProductsDataLoadingState extends HomeStates {}

class GetProductsDataSuccessState extends HomeStates {}

class GetProductsDataErrorState extends HomeStates {}

class GetBannersDataLoadingState extends HomeStates {}

class GetBannersDataSuccessState extends HomeStates {}

class GetBannersDataErrorState extends HomeStates {}

class ChangeBottomNavState extends HomeStates {}

class ChangeIconFavoriteState extends HomeStates {}

class FailedChangeFavoriteState extends HomeStates {}

class ChangeIconCartState extends HomeStates {}

class FailedChangeCartState extends HomeStates {}
