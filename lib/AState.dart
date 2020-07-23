import 'package:flutter/material.dart';

class A extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AState();
}

class AState extends State<A> {
  bool bDependenciesShouldChange = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 15), () {
      bDependenciesShouldChange = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    /// once `the architecture layers of B's dependent Widgets` changes, B will call `didChangeDependencies`. (e.g. `Scaffold`、`Container`、`C`、`B` => `Scaffold`、`Container`、`C`、`SizedBox`、`B`)，
    return bDependenciesShouldChange
        ? Scaffold(
            body: Container(
            height: 500,
            alignment: Alignment.centerLeft,
            child: C(child: B()),
          ))
        : Scaffold(
            body: Container(
            height: 300,
            alignment: Alignment.centerLeft,
            child: C(child: SizedBox(width: 200, height: 300, child: B())),
          ));

    /// once `type of any widget node in the architecture of B's dependent Widgets` changes, B will call `didChangeDependencies`. (e.g. `Container` => `Center`)，
    // return bDependenciesShouldChange
    //     ? Scaffold(body: Center(child: C(child: B())))
    //     : Scaffold(
    //         body: Container(
    //         height: 500,
    //         alignment: Alignment.centerLeft,
    //         child: C(child: B()),
    //       ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("A didChangeDependencies");
  }
}

class B extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BState();
}

class BState extends State<B> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("B"));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("B didChangeDependencies");
  }
}

class C extends StatefulWidget {
  final Widget child;

  C({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CState();
}

class CState extends State<C> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("C didChangeDependencies");
  }
}
