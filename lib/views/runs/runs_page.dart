import 'package:RuneoDriverFlutter/bloc/authentication/index.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:RuneoDriverFlutter/bloc/index.dart';
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
								title: (barcode != null) ? Text(barcode.rawContent) : Text("Runéo"),
								actions: <Widget>[
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

  Future barcodeScanning() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = barcode.type as ScanResult;
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e' as ScanResult);
      }
    } on FormatException {
      setState(() => this.barcode = barcode.formatNote as ScanResult);
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e' as ScanResult);
    }
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

Widget buildRunList(List<Run> runs) => ListView.builder(
	itemCount: runs.length,
     itemBuilder: (context, index) => RunListItem(
      run: runs[index],
     )
  );