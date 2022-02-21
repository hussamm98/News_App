import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:news_app/network/locale/cache.dart';
import 'package:news_app/network/remote/dio.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'layout/news_layout.dart';
import 'shared/cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  bool dark = CacheHelper.getBoolean(key: 'dark');
  runApp(MyApp(dark));
}

class MyApp extends StatelessWidget {
  final bool dark;
  MyApp(this.dark);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NewsCubit()..getBusiness()..changeTheme())
        ],
        child: BlocConsumer<NewsCubit, NewsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            NewsCubit cubit = NewsCubit.getCubit(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'News Application',
              theme: ThemeData(
                primarySwatch: Colors.deepOrange,
                scaffoldBackgroundColor: Colors.white,
                textTheme: TextTheme(
                  bodyText1: TextStyle(
                    color: HexColor('333739'),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                appBarTheme: AppBarTheme(
                  titleSpacing: 20.0,
                  titleTextStyle: TextStyle(
                      color: HexColor('333739'),
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0),
                  iconTheme: IconThemeData(
                    color: HexColor('333739'),
                  ),
                  color: Colors.white,
                  elevation: 0.0,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  elevation: 8.0,
                  unselectedItemColor: HexColor('333739'),
                ),
              ),
              themeMode: cubit.dark ? ThemeMode.dark : ThemeMode.light,
              darkTheme: ThemeData(
                primarySwatch: Colors.deepOrange,
                scaffoldBackgroundColor: HexColor('333739'),
                textTheme: const TextTheme(
                  bodyText1: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                appBarTheme: AppBarTheme(
                  titleSpacing: 20.0,
                  titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  color: HexColor('333739'),
                  elevation: 0.0,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: HexColor('333739'),
                  elevation: 8.0,
                  unselectedItemColor: Colors.white,
                ),
              ),
              home: const NewsLayout(),
            );
          },
        ));
  }
}
