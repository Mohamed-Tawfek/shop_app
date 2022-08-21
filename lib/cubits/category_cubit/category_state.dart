part of 'category_cubit.dart';

@immutable
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class LoadingCategoriesData extends CategoriesState {}

class SuccessInGetCategoriesData extends CategoriesState {}

class ErrorInGetCategoriesData extends CategoriesState {}

class LoadingCategoryDetails extends CategoriesState {}

class SuccessInGetCategoryDetails extends CategoriesState {}

class ErrorInGetCategoryDetails extends CategoriesState {}
class ChangeIconCartState extends CategoriesState {}
class FailedChangeCartState extends CategoriesState {}
class FailedChangeFavoriteState extends CategoriesState {}
class ChangeIconFavoriteState extends CategoriesState {}
