import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterButton extends StatelessWidget {
  final bool visible;

  FilterButton({
    this.visible,
    Key key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyText1;
    final activeStyle = Theme.of(context)
      .textTheme
      .bodyText1
      .copyWith(color: Theme.of(context).accentColor);
    final RunBloc runBloc =
      BlocProvider.of <RunBloc> (context);
    return BlocBuilder<RunBloc, RunState>(
      builder: (BuildContext context, RunState state) {
        final button = _Button(
          onSelected: (filter) {
            BlocProvider.of <RunBloc> (context)
              .add(FilterUpdated(filter));
          },
          activeFilter: state is RunLoadedState ?
          state.activeFilter :
          "all",
          activeStyle: activeStyle,
          defaultStyle: defaultStyle,
        );
        return AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 150),
          child: visible ? button : IgnorePointer(child: button),
        );
      }
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key key,
    @required this.onSelected,
    @required this.activeFilter,
    @required this.activeStyle,
    @required this.defaultStyle,
  }): super(key: key);

  final PopupMenuItemSelected <String> onSelected;
  final String activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton <String> (
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => < PopupMenuItem <String>> [
        PopupMenuItem <String> (
          value: "all",
          child: Text(
            "Show all",
            style: activeFilter == "all" ?
            activeStyle :
            defaultStyle,
          ),
        ),
        PopupMenuItem <String> (
          value: "mine",
          child: Text(
            "Show mine",
            style: activeFilter == "mine" ?
            activeStyle :
            defaultStyle,
          ),
        ),
        PopupMenuItem <String> (
          value: "drafting",
          child: Text(
            "Show in progress",
            style: activeFilter == "drafting" ?
            activeStyle :
            defaultStyle,
          ),
        ),
        PopupMenuItem <String> (
          value: "needs_filling",
          child: Text(
            "Show needs filling",
            style: activeFilter == "needs_filling" ?
            activeStyle :
            defaultStyle,
          ),
        ),
        PopupMenuItem <String> (
          value: "finished",
          child: Text(
            "Show finished",
            style: activeFilter == "finished" ?
            activeStyle :
            defaultStyle,
          ),
        ),
      ],
      icon: Icon(Icons.filter_list),
    );
  }
}