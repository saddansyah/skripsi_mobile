import 'package:flutter/material.dart';
import 'package:skripsi_mobile/models/abstracts/has_id.dart';
import 'package:skripsi_mobile/theme.dart';

class SelectButtomSheet<T extends HasId> extends StatefulWidget {
  const SelectButtomSheet({
    super.key,
    required this.onConfirmPressed,
    required this.title,
    required this.message,
    this.color,
    this.select,
    required this.data,
    required this.initialValue,
    required this.updateSelected,
  });

  final void Function() onConfirmPressed;
  final String title;
  final String message;
  final Color? color;
  final String? select;
  final List<T> data;
  final T initialValue;
  final void Function(T) updateSelected;

  @override
  State<SelectButtomSheet> createState() =>
      _SelectButtomSheetState<T>();
}

class _SelectButtomSheetState<T extends HasId>
    extends State<SelectButtomSheet<T>> {
  late T _selected;

  void updateSelected(T newSelected) {
    setState(() {
      _selected = newSelected;
    });
    widget.updateSelected(newSelected);
  }

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue as T;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Container(
          padding: EdgeInsets.only(top: 12),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    widget.title,
                    style: Fonts.bold18,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.message,
                    style: Fonts.regular12,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.data.length,
                          itemBuilder: (c, i) => GestureDetector(
                            onTap: () {
                              updateSelected(widget.data[i] as T);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(6, 6, 6, 0),
                              padding: EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: _selected.id == widget.data[i].id
                                    ? AppColors.greenAccent
                                    : AppColors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                                border: Border.all(
                                    width: 2, color: Colors.grey[350]!),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    widget.data[i].name,
                                    style: Fonts.semibold14,
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.location_city_rounded,
                                    color: AppColors.bluePrimary,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: widget.color ?? AppColors.greenPrimary,
                    foregroundColor: AppColors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    )),
                onPressed: widget.onConfirmPressed,
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: double.infinity,
                  child: Text(
                    widget.select ?? 'Pilih',
                    style: Fonts.bold16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
