import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/sport/sport_screen.dart';
import 'package:news_app/network/locale/cache.dart';
import 'package:news_app/network/remote/dio.dart';
import 'package:news_app/shared/cubit/states.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit getCubit(context) => BlocProvider.of(context);

  List<BottomNavigationBarItem> bottomNavigation = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.business_center_outlined),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports_basketball_outlined),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.science_outlined),
      label: 'Science',
    ),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportScreen(),
    ScienceScreen(),
  ];
  int currentIndex = 0;

  void changeBottomNav(int index) {
    currentIndex = index;
    if (index == 1) getSports();
    if (index == 2) getScience();
    emit(ChangeBottomNavBarState());
  }

  List<dynamic> business = [];

  void getBusiness() {
    if (business.length == 0) {
      emit(NewsGetBusinessLoadingState());
      DioHelper.getDio(url: 'v2/top-headlines', query: {
        'country': 'eg',
        'category': 'business',
        'apiKey': 'ddb5016752704ca98863429003034239',
      }).then((value) {
        business = value.data['articles'];
        emit(NewsGetBusinessSuccessState());
      }).catchError((error) {
        print("Error = ${error.toString()}");
        emit(NewsGetBusinessErrorState(error));
      });
    } else {
      emit(NewsGetBusinessSuccessState());
    }
  }

  List<dynamic> sports = [];

  void getSports() {
    emit(NewsGetSportsLoadingState());
    if (sports.length == 0) {
      DioHelper.getDio(url: 'v2/top-headlines', query: {
        'country': 'eg',
        'category': 'sports',
        'apiKey': 'ddb5016752704ca98863429003034239',
      }).then((value) {
        sports = value.data['articles'];
        emit(NewsGetSportsSuccessState());
      }).catchError((error) {
        print("Error = ${error.toString()}");
        emit(NewsGetSportsErrorState(error));
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> science = [];

  void getScience() {
    emit(NewsGetScienceLoadingState());
    if (science.length == 0) {
      DioHelper.getDio(url: 'v2/top-headlines', query: {
        'country': 'eg',
        'category': 'science',
        'apiKey': 'ddb5016752704ca98863429003034239',
        // 'apiKey' : '65f7f556ec76449fa7dc7c0069f040ca',
      }).then((value) {
        science = value.data['articles'];
        print(value.data);
        emit(NewsGetScienceSuccessState());
      }).catchError((error) {
        print("Error = ${error.toString()}");
        emit(NewsGetScienceErrorState(error));
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  List<dynamic> search = [];

  void getSearch(String value) {
    emit(NewsGetSearchLoadingState());
    DioHelper.getDio(url: 'v2/everything', query: {
      'q': '$value',
      'apiKey': 'ddb5016752704ca98863429003034239',
    }).then((value) {
      search = value.data['articles'];
      emit(NewsGetSearchSuccessState());
    }).catchError((error) {
      print('error search = ${error.toString()}');
      emit(NewsGetSearchErrorState(error));
    });
  }

  bool dark = true;

  void changeTheme({bool fromShared}) {
    if (fromShared != null) {
      dark = fromShared;
      emit(ThemeModeState());
    } else {
      dark = !dark;
      CacheHelper.putBoolean(key: 'dark', value: dark).then((value) {
        emit(ThemeModeState());
      });
    }
  }
}
