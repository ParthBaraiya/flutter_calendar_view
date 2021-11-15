import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../app_colors.dart';
import '../constants.dart';
import '../extension.dart';
import 'custom_button.dart';
import 'date_time_selector.dart';

class AddEventWidget extends StatefulWidget {
  final void Function(CalendarEventData)? onEventAdd;
  const AddEventWidget({
    Key? key,
    this.onEventAdd,
  }) : super(key: key);

  @override
  _AddEventWidgetState createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
  late DateTime _startDate;
  late DateTime _endDate;

  late DateTime _startTime;

  late DateTime _endTime;

  String _title = "";

  String _description = "";

  Color _color = Colors.blue;

  late FocusNode _titleNode;
  late FocusNode _descriptionNode;
  late FocusNode _startDateNode;
  late FocusNode _endDateNode;

  final GlobalKey<FormState> _form = GlobalKey();

  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();

    _startDate = _endDate = _startTime = _endTime = DateTime.now();

    _titleNode = FocusNode();
    _descriptionNode = FocusNode();
    _startDateNode = FocusNode();
    _endDateNode = FocusNode();

    _startDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _endDateController = TextEditingController();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();
    _startDateNode.dispose();
    _endDateNode.dispose();

    _startDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _endDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: AppConstants.inputDecoration.copyWith(
              labelText: "Event Title",
            ),
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            onSaved: (value) => _title = value?.trim() ?? "",
            validator: (value) {
              if (value == null || value == "")
                return "Please enter event title.";

              return null;
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  displayDefault: true,
                  minimumDateTime: DateTime.now(),
                  controller: _startDateController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Start Date",
                  ),
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select date.";

                    return null;
                  },
                  onSelect: (date) {
                    _startDate = date ?? _startDate;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _startDate = date,
                  type: DateTimeSelectionType.date,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  displayDefault: true,
                  minimumDateTime: _startDate,
                  controller: _endDateController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "End Date",
                  ),
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select date.";

                    if (_endDate.difference(_startDate).inDays < 0)
                      return "Please select valid date.";
                    return null;
                  },
                  onSelect: (date) {
                    _endDate = date ?? _endDate;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _endDate = date,
                  type: DateTimeSelectionType.date,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  displayDefault: true,
                  controller: _startTimeController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Start Time",
                  ),
                  onSelect: (date) {
                    if (date == null) return;

                    _startTime = DateTime(
                      _startDate.year,
                      _startDate.month,
                      _startDate.day,
                      date.hour,
                      date.minute,
                    );
                  },
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select start time.";

                    if (!_validateDates()) return "Please select valid date.";

                    return null;
                  },
                  onSave: (date) {
                    _startTime = DateTime(
                      _startDate.year,
                      _startDate.month,
                      _startDate.day,
                      date.hour,
                      date.minute,
                    );
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  controller: _endTimeController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "End Time",
                  ),
                  onSelect: (date) {
                    if (date == null) return;

                    _endTime = DateTime(
                      _startDate.year,
                      _startDate.month,
                      _startDate.day,
                      date.hour,
                      date.minute,
                    );
                  },
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select end time.";

                    if (!_validateDates()) return "Please select valid date.";

                    return null;
                  },
                  onSave: (date) {
                    _endTime = DateTime(
                      _startDate.year,
                      _startDate.month,
                      _startDate.day,
                      date.hour,
                      date.minute,
                    );
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            focusNode: _descriptionNode,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            selectionControls: MaterialTextSelectionControls(),
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            validator: (value) {
              if (value == null || value.trim() == "")
                return "Please enter event description.";

              return null;
            },
            onSaved: (value) => _description = value?.trim() ?? "",
            decoration: AppConstants.inputDecoration.copyWith(
              hintText: "Event Description",
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Text(
                "Event Color: ",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: _displayColorPicker,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: _color,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            onTap: _createEvent,
            title: "Add Event",
          ),
        ],
      ),
    );
  }

  bool _validateDates() =>
      _startTime.difference(_endTime).inMinutes != 0 &&
      _startTime.isBefore(_endTime);

  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData(
      date: _startDate,
      endDate: _endDate,
      color: _color,
      endTime: _endTime,
      startTime: _startTime,
      description: _description,
      title: _title,
    );

    widget.onEventAdd?.call(event);
    _resetForm();
  }

  void _resetForm() {
    _form.currentState?.reset();
    _startDateController.text = "";
    _endTimeController.text = "";
    _startTimeController.text = "";
  }

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: AppColors.bluishGrey,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Event Color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Select",
                onTap: () {
                  if (mounted)
                    setState(() {
                      _color = color;
                    });
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
