import 'package:RuneoDriverFlutter/bloc/authentication/index.dart';
import 'package:RuneoDriverFlutter/views/runs/widgets/filter_button.dart';
import 'package:RuneoDriverFlutter/views/shared/loading_indicator.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/views/runs/widgets/run_list_item.dart';

class RunsPage extends StatefulWidget {
	@override
	_RunsPageState createState() => _RunsPageState();
}

class _RunsPageState extends State<RunsPage> {
	RunBloc runBloc;
  ScanResult barcode;

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
								title: Text("Runéo"),
								actions: <Widget>[
                  FilterButton(visible: true),
                  IconButton(
										icon: Icon(Icons.exit_to_app),
										onPressed: ()  {
											BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
										},
									),
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
                        return LoadingIndicator();
                      } else if (state is RunLoadingState) {
                        return LoadingIndicator();
                      } else if (state is RunLoadedState) {
                        if (state.runs != null && state.runs.length > 0) {
                          return _buildRunList(state.runs);
                        } else {
                          return _buildNoDataView(context);
                        }
                      } else if (state is RunErrorState) {
                        return _buildErrorUi(state.message);
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

Widget _buildNoDataView(BuildContext context) => Center(
        child: Column(
          children: <Widget>[
            Text(
              "No runs yet.",
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ],
        ),
      );

Widget _buildErrorUi(String message) {
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

Widget _buildRunList(List<Run> runs) => ListView.builder(
	itemCount: runs.length,
     itemBuilder: (context, index) => RunListItem(
      run: runs[index],
     )
  );