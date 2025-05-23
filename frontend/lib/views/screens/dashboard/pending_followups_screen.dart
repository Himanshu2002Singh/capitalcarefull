import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/leads/lead_details_screen.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class PendingFollowUpsScreen extends StatelessWidget {
  final title;
  PendingFollowUpsScreen({super.key, required this.title});
  final List<FollowUp> followUps = [
    FollowUp(
      dateTime: '10 May 2025\n02:00 pm',
      name: 'Deol',
      number: '9717758933',
      caller: 'Pradeep',
      lastCall: '',
    ),
    FollowUp(
      dateTime: '10 May 2025\n01:30 pm',
      name: 'pk',
      number: '9995816744',
      caller: 'Pradeep',
      lastCall: 'call back',
    ),
    FollowUp(
      dateTime: '07 May 2025\n04:49 pm',
      name: 'afe',
      number: '5467890435',
      caller: 'Mukund',
      lastCall: 'asfadsf',
    ),
    FollowUp(
      dateTime: '05 May 2025\n05:09 pm',
      name: 'ram',
      number: '9999977888',
      caller: 'Pradeep',
      lastCall: 'hhhhhh',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isFloatingActionButton: false,
      appBar: CustomAppbar(
        title: title,
        action: const [Icon(Icons.search), SizedBox(width: 16)],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10),
          Text(
            'Total FollowUps - ${followUps.length}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: followUps.length,
              itemBuilder: (context, index) {
                final f = followUps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 160,
                          width: 100,

                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              f.dateTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        f.name,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder:
                                        //         (context) =>
                                        //             LeadDetailsScreen(),
                                        //   ),
                                        // );
                                      },
                                      icon: Icon(Icons.remove_red_eye),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_android,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      f.number,
                                      style: const TextStyle(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(f.caller),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.call, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text("Last call:- ${f.lastCall}"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FollowUp {
  final String dateTime;
  final String name;
  final String number;
  final String caller;
  final String lastCall;

  FollowUp({
    required this.dateTime,
    required this.name,
    required this.number,
    required this.caller,
    required this.lastCall,
  });
}
