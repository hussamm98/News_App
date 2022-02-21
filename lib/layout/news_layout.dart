import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/search/search_screen.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';

class NewsLayout extends StatelessWidget {
  const NewsLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          NewsCubit cubit = NewsCubit.getCubit(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('News'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.search_outlined),
                ),
                IconButton(
                  onPressed: () {
                    cubit.changeTheme();
                  },
                  icon: Icon(Icons.brightness_4_outlined),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              items: cubit.bottomNavigation,
              onTap: (index) {
                cubit.changeBottomNav(index);
              },
            ),
            body: cubit.screens[cubit.currentIndex],
          );
        });
  }
}
