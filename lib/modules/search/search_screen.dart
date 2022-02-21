import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/component/shared_component.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.getCubit(context).search;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultFormField(
                  onChange: (value) {
                    NewsCubit.getCubit(context).getSearch(value);
                  },
                  label: 'Search',
                  prefix: Icons.search,
                ),
              ),
              Expanded(
                child: ConditionalBuilder(condition: list.length>0,
                  builder: (context)=>  ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder:(context, index)=>buildArticleItem(list[index],context) ,
                    separatorBuilder: (context,index)=> myDivider(context),
                    itemCount: list.length,
                  ),
                  fallback:(context)=> const Center(child: CircularProgressIndicator(),),),),
            ],
          ),
        );
      },
    );
  }
}
