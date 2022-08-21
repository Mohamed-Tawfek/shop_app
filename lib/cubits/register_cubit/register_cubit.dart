import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/register_cubit/register_state.dart';


class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  RegisterCubit  get(context)=>BlocProvider.of(context);
}
