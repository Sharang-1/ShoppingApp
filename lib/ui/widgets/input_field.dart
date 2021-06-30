import 'package:compound/ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared/ui_helpers.dart';
import 'note_text.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool password;
  final bool isReadOnly;
  final String placeholder;
  final String validationMessage;
  final Function enterPressed;
  final bool smallVersion;
  final bool fromBottomsheet;
  final FocusNode fieldFocusNode;
  final FocusNode nextFocusNode;
  final TextInputAction textInputAction;
  final String additionalNote;
  final Function(String) onChanged;
  final TextInputFormatter formatter;
  final bool autoFocus;
  final double fontSize;

  InputField({
    @required this.controller,
    @required this.placeholder,
    this.enterPressed,
    this.fieldFocusNode,
    this.nextFocusNode,
    this.additionalNote,
    this.onChanged,
    this.formatter,
    this.validationMessage,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.password = false,
    this.isReadOnly = false,
    this.smallVersion = false,
    this.fromBottomsheet = false,
    this.autoFocus = false,
    this.fontSize,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isPassword;
  double fieldHeight;
  double fontSize;

  @override
  void initState() {
    super.initState();
    fieldHeight = (widget.smallVersion || widget.fromBottomsheet) ? 40 : 55;

    fontSize = (widget.fontSize != null)
        ? widget.fontSize
        : widget.fromBottomsheet
            ? titleFontSizeStyle
            : widget.smallVersion
                ? 15
                : 20;

    isPassword = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: fieldHeight,
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  autofocus: widget.autoFocus,
                  controller: widget.controller,
                  keyboardType: widget.textInputType,
                  focusNode: widget.fieldFocusNode,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  inputFormatters:
                      widget.formatter != null ? [widget.formatter] : null,
                  onEditingComplete: () {
                    if (widget.enterPressed != null) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.enterPressed();
                    }
                  },
                  onFieldSubmitted: (value) {
                    widget.fieldFocusNode.unfocus();
                    if (widget.nextFocusNode != null) {
                      widget.nextFocusNode.requestFocus();
                    }
                  },
                  obscureText: isPassword,
                  readOnly: widget.isReadOnly,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: widget.fromBottomsheet
                          ? FontWeight.normal
                          : FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  isPassword = !isPassword;
                }),
                child: widget.password
                    ? Container(
                        width: fieldHeight,
                        height: fieldHeight,
                        alignment: Alignment.center,
                        child: Icon(isPassword
                            ? Icons.visibility
                            : Icons.visibility_off))
                    : Container(),
              ),
            ],
          ),
        ),
        if (widget.validationMessage != null)
          NoteText(
            widget.validationMessage,
            color: Colors.red,
          ),
        if (widget.additionalNote != null) verticalSpace(5),
        if (widget.additionalNote != null) NoteText(widget.additionalNote),
        verticalSpaceSmall
      ],
    );
  }
}
