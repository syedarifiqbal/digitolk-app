import 'package:digitolk_test/core/helper.dart';
import 'package:digitolk_test/core/toastr.dart';
import 'package:digitolk_test/services/task_service.dart';
import 'package:digitolk_test/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateIndexPage extends StatefulWidget {
  static const String name = "CREATE INDEX";
  final ValueChanged<int> onBackClick;
  const CreateIndexPage(
      {Key? key, required String parentScreen, required this.onBackClick})
      : super(key: key);

  @override
  State<CreateIndexPage> createState() => _CreateIndexPageState();
}

class _CreateIndexPageState extends State<CreateIndexPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String summary = "";
  String description = "";
  String due_at = "";
  final TextEditingController _dueAtController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => widget.onBackClick(0),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      "New Task",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    Text('Back', style: TextStyle(color: Colors.transparent)),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _summaryController,
                  decoration: const InputDecoration(
                      hintText: "Summary",
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffE8E8E8), width: 2.0),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffE8E8E8),
                        ),
                      ),
                      prefixIcon: Icon(CupertinoIcons.chat_bubble_text)),
                  onChanged: (value) => summary = value,
                  validator: RequiredValidator(
                    errorText: "Summary is required.",
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: "Description",
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffE8E8E8), width: 2.0),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffE8E8E8),
                      ),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 90.0),
                      child: Icon(
                        Icons.wrap_text,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) => description = value,
                  validator: RequiredValidator(
                    errorText: "Description is required.",
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  readOnly: true,
                  controller: _dueAtController,
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(2018, 3, 5),
                      maxTime: DateTime(2019, 6, 7),
                      onChanged: (date) {
                        // print('change $date');
                      },
                      onConfirm: (date) {
                        // print('confirm $date');
                        setState(
                          () {
                            due_at = date.toString().split('.')[0];
                            _dueAtController.text = (due_at);
                          },
                        );
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en,
                    );
                  },
                  decoration: const InputDecoration(
                      hintText: "Due Date",
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffE8E8E8), width: 2.0),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffE8E8E8),
                        ),
                      ),
                      prefixIcon: Icon(CupertinoIcons.clock)),
                  onChanged: (value) => summary = value,
                  validator: RequiredValidator(
                    errorText: "Due date is required.",
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                PrimaryButton(
                  title: "Save",
                  onTab: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    String message = await TaskService.create(
                      summary: summary,
                      description: description,
                      due_at: due_at,
                    );
                    _summaryController.text = "";
                    _descriptionController.text = "";
                    _dueAtController.text = "";
                    Toastr(message: message).show();
                    widget.onBackClick(0);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
