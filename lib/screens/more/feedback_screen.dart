import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/common_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  var _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: KangaAppbar(
          title: S.current.feedback,
        ),
        body: Padding(
          padding: const EdgeInsets.all(offsetXMd),
          child: Column(
            children: [
              Image.asset(
                'assets/images/circularLogo.png',
                width: 120.0,
              ),
              SizedBox(
                height: offsetXLg,
              ),
              KangaTextField(
                controller: _feedbackController,
                textInputAction: TextInputAction.done,
                isMemo: true,
                hintText: S.current.giveMeFeedback,
              ),
              Spacer(),
              KangaButton(
                onPressed: () => _addFeedback(),
                btnText: S.current.submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addFeedback() async {
    var feedback = _feedbackController.text;
    if (feedback.isEmpty) {
      DialogProvider.of(context).showSnackBar(
        S.current.emptyFeedback,
        type: SnackBarType.ERROR,
      );
      return;
    }
    var res = await NetworkProvider.of(context).post(
      Constants.header_profile,
      Constants.link_add_feedback,
      {
        'content': feedback,
      },
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      DialogProvider.of(context).showSnackBar(
        S.current.successFeedback,
      );
      Future.delayed(
          Duration(milliseconds: 2500), () => Navigator.of(context).pop());
    } else {
      DialogProvider.of(context).showSnackBar(
        res['msg'],
        type: SnackBarType.ERROR,
      );
    }
  }
}
