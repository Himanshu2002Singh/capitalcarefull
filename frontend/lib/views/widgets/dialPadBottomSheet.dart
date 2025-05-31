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

  void onKeyTap(String value) {
    if (input.length < 10) {
      setState(() {
        input += value;
      });
    }
  }

  void onDelete() {
    if (input.isNotEmpty) {
      setState(() {
        input = input.substring(0, input.length - 1);
      });
    }
  }

  void onCopy() {
    Clipboard.setData(ClipboardData(text: input));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Copied to clipboard")));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row with Copy Icon and Display
          Row(
            children: [
              IconButton(icon: Icon(Icons.copy), onPressed: onCopy),
              Expanded(
                child: Text(
                  input,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(icon: Icon(Icons.backspace), onPressed: onDelete),
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
          // Call Buttons
          ElevatedButton.icon(
            onPressed: () {
              makeDirectCall(input);
            },
            icon: Icon(Icons.call),
            label: Text("Call"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(20),
              //     bottomLeft: Radius.circular(20),
              //   ),
              // ),
            ),
          ),
        ],
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

    if (await Permission.phone.isGranted) {
      await FlutterPhoneDirectCaller.callNumber(number);
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
