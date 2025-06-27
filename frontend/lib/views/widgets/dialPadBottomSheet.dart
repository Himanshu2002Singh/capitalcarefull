import 'package:capital_care/models/leads_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/call_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class DialPadBottomSheet extends StatefulWidget {
  @override
  _DialPadBottomSheetState createState() => _DialPadBottomSheetState();
}

class _DialPadBottomSheetState extends State<DialPadBottomSheet> {
  String input = '';
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = input;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void onKeyTap(String value) {
    final cursorPos = _controller.selection.baseOffset;
    final text = _controller.text;

    if (text.length < 10 && cursorPos >= 0) {
      final newText =
          text.substring(0, cursorPos) + value + text.substring(cursorPos);
      setState(() {
        input = newText;
        _controller.text = newText;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorPos + 1),
        );
      });
    }
  }

  void onDelete() {
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;

    if (cursorPos > 0) {
      final newText =
          text.substring(0, cursorPos - 1) + text.substring(cursorPos);
      setState(() {
        input = newText;
        _controller.text = newText;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorPos - 1),
        );
      });
    }
  }

  void onClearAll() {
    setState(() {
      input = '';
      _controller.clear();
    });
  }

  void onCopy() {
    Clipboard.setData(ClipboardData(text: _controller.text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Copied to clipboard")));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Copy, TextField, Delete Row
            Row(
              children: [
                IconButton(icon: Icon(Icons.copy), onPressed: onCopy),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    readOnly: true,
                    showCursor: true,
                    enableInteractiveSelection: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration.collapsed(hintText: ''),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.backspace),
                  onPressed: onDelete,
                  onLongPress: onClearAll,
                ),
              ],
            ),
            SizedBox(height: 10),

            // Number Pad
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton("1"),
                      _buildButton("2"),
                      _buildButton("3"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton("4"),
                      _buildButton("5"),
                      _buildButton("6"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton("7"),
                      _buildButton("8"),
                      _buildButton("9"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton("*"),
                      _buildButton("0"),
                      _buildButton("#"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Call Button
            ElevatedButton.icon(
              onPressed: () {
                makeDirectCall(_controller.text);
              },
              icon: Icon(Icons.call),
              label: Text("Call"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String val) {
    return Container(
      height: ((MediaQuery.of(context).size.height / 3)) / 4,
      width: (MediaQuery.of(context).size.width - 25) / 3,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        onPressed: () {
          onKeyTap(val);
        },
        child: Text(
          "$val",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Future<void> makeDirectCall(String number) async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      await Permission.phone.request();
    }

    if (await Permission.phone.isGranted && number.isNotEmpty) {
      await FlutterPhoneDirectCaller.callNumber(number);
      // Leads lead = ApiService().getLeadWithNumber(number);
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallDetailsScreen(number: number),
          ),
        );
      });
    }
  }
}
