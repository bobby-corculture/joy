import 'package:flutter/material.dart';
import 'package:corculture_personal_growth/components/text_fields.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedBackPage extends StatefulWidget {
  FeedBackPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  final _formKey = GlobalKey<FormState>();
  bool _enableBtn = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return makeEmailForm();
  }

  Widget makeEmailForm() {
    return Scaffold(
        appBar: AppBar(
        title: Text('Contact Corculture'),
    ),
    body: Form(
      key: _formKey,
      onChanged: (() {
        setState(() {
          _enableBtn = _formKey.currentState!.validate();
        });
      }),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFields(
                controller: subjectController,
                name: "Subject",
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                })),
            TextFields(
                controller: messageController,
                name: "Message",
                validator: ((value) {
                  if (value!.isEmpty) {
                    setState(() {
                      _enableBtn = true;
                    });
                    return 'Message is required';
                  }
                  return null;
                }),
                maxLines: null,
                type: TextInputType.multiline),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          else if (states.contains(MaterialState.disabled))
                            return Colors.grey;
                          return Colors.blue; // Use the component's default.
                        },
                      ),
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ))),
                  onPressed: _enableBtn
                      ? (() async {
                    final Email email = Email(
                      body: messageController.text,
                      subject: subjectController.text,
                      recipients: ['app.contact@corculture.org'],
                      isHTML: false,
                    );
                    await FlutterEmailSender.send(email);
                  })
                      : null,
                  child: Text('Submit'),
                )),
          ],
        ),
      ),
    ));
  }
}

