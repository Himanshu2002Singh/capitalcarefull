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
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ...[
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '*',
                '0',
                '#',
              ].map(
                (val) => InkWell(
                  onTap: () => onKeyTap(val),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: Text(val, style: TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
              ),
            ],
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

  Future<void> makeDirectCall(String number) async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      await Permission.phone.request();
    }

    if (await Permission.phone.isGranted) {
      await FlutterPhoneDirectCaller.callNumber(number);
      Future.delayed(Duration(seconds: 2), () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => CallDetailsScreen()),
        // );
      });
    }
  }
}
