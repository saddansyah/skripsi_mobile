import 'package:flutter/material.dart';

class KeepAlivePageView extends StatefulWidget {
  const KeepAlivePageView({super.key, required this.child});

  final Widget child;

  @override
  State<KeepAlivePageView> createState() => _KeepAlivePageViewState();
}

class _KeepAlivePageViewState extends State<KeepAlivePageView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
