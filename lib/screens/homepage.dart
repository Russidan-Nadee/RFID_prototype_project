import 'package:flutter/material.dart';
import 'package:rfid_project/screens/RFIDscan.dart';
import 'package:rfid_project/screens/Searchpage.dart';
import 'package:rfid_project/screens/Viewassets.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment:
            CrossAxisAlignment.center, // ทำให้ปุ่ม fill เต็มความกว้าง
        children: [


          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const Rfidscan();
              }));
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.8, // กำหนดความกว้างเท่ากันทุกปุ่ม
                MediaQuery.of(context).size.height * 0.1,
               // กำหนดความสูงเท่ากันทุกปุ่ม
              ),
              backgroundColor: const Color.fromARGB(255, 223, 234, 240),
            ),
            child: const Text(
              "RFID Scan Reader",
              style: TextStyle(fontSize: 20, letterSpacing: 2),
            ),
          ),


          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const Viewassets();
              }));
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.1,
              ),
              backgroundColor: const Color.fromARGB(255, 223, 234, 240),
            ),
            child: const Text(
              "View Assets",
              style: TextStyle(fontSize: 20, letterSpacing: 2),
            ),
          ),


          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const Searchpage();
              }));
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.1,
              ),
              backgroundColor: const Color.fromARGB(255, 223, 234, 240),
            ),
            child: const Text(
              "Search Assets",
              style: TextStyle(fontSize: 20, letterSpacing: 2),
            ),
          ),


          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.1,
              ),
              backgroundColor: const Color.fromARGB(255, 223, 234, 240),
            ),
            child: const Text(
              "Export Audit Data",
              style: TextStyle(fontSize: 20, letterSpacing: 2),
            ),
          ),
        ],
      ),
    );
  }
}
