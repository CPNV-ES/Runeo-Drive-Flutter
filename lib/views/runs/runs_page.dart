import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:RuneoDriverFlutter/bloc/index.dart';

class RunsPage extends StatefulWidget {
	@override
	_RunsPageState createState() => _RunsPageState();
}

class _RunsPageState extends State<RunsPage> {
	RunBloc runBloc;

	@override
	void initState() {
		super.initState();
		runBloc = BlocProvider.of<RunBloc>(context);
		runBloc.add(GetRunsEvent());
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			home: Builder(
				builder: (context) {
					return Material(
						child: Scaffold(
							appBar: AppBar(
								title: Text("Runeo"),
								actions: <Widget>[
									IconButton(
										icon: Icon(Icons.refresh),
										onPressed: () {
											runBloc.add(GetRunsEvent());
										},
									),
								]
							),
							body: Container(
								child: BlocListener<RunBloc, RunState>(
									listener: (context, state) {
										if (state is RunErrorState) {
											Scaffold.of(context).showSnackBar(
												SnackBar(
													content: Text(state.message),
												)
											);
										}
									},
									child: BlocBuilder<RunBloc, RunState>(
										builder: (context, state) {
											if (state is RunInitalState) {
                        return buildLoading();
                      } else if (state is RunLoadingState) {
                        return buildLoading();
                      } else if (state is RunLoadedState) {
                        return buildRunList(state.runs);
                      } else if (state is RunErrorState) {
                        return buildErrorUi(state.message);
                      }
										}
									)
								)
							)
						)
					);
				}
			)
		);
	}
}

Widget buildLoading() {
	return Center(
    child: CircularProgressIndicator(),
	);
}

Widget buildErrorUi(String message) {
	return Center(
		child: Padding(
			padding: const EdgeInsets.all(8.0),
			child: Text(
				message,
				style: TextStyle(color: Colors.red),
			),
		),
	);
}

Widget buildRunList(List<Run> runs) {
	return ListView.builder(
		itemCount: runs.length,
		itemBuilder: (ctx, pos) {
			return Padding(
				padding: const EdgeInsets.all(8.0),
				child: InkWell(
					child: ListTile(
						leading: ClipOval(
							child: Hero(
								tag: runs[pos].title,
								child: Text(runs[pos].status),
							),
						),
						title: Text(runs[pos].title),
						subtitle: Text(runs[pos].beginAt),
					),
				),
			);
		},
	);
}