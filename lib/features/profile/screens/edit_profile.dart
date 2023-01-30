import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditProfile extends StatelessWidget {
  static const routeName = '/edit-profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile Screen'),
      ),

      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: EdgeInsets.all(10),
        child: ListView(children: <Widget>[


        


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                decoration: const InputDecoration(
                  // border: InputBorder.none,
                   border: OutlineInputBorder(
              borderSide: BorderSide(),
        ),
                  labelText: 'Full Name',
                  labelStyle: TextStyle(
                    color: Colors.black, //<-- SEE HERE
                  ),

                  
                ),
              ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                decoration: const InputDecoration(
                  // border: InputBorder.none,
                   border: OutlineInputBorder(
              borderSide: BorderSide(),
        ),
                  labelText: 'Email ID',
                  labelStyle: TextStyle(
                    color: Colors.black, //<-- SEE HERE
                  ),

                  
                ),
              ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntlPhoneField(
              // textAlign: TextAlign.left,
                  decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: Colors.black, //<-- SEE HERE
                  ),
                  border: OutlineInputBorder(
              borderSide: BorderSide(),
        ),
                  ),
                  initialCountryCode: 'IN',
              onChanged: (phone) {
              print(phone.completeNumber);
                },
              ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                decoration: const InputDecoration(
                  // border: InputBorder.none,
                   border: OutlineInputBorder(
              borderSide: BorderSide(),
        ),
                  labelText: 'City',
                  labelStyle: TextStyle(
                    color: Colors.black, //<-- SEE HERE
                  ),

                  
                ),
              ),
          ),



Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              
              // keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  // border: InputBorder.none,
                   border: OutlineInputBorder(
              borderSide: BorderSide(),
        ),
                  labelText: 'Address',
                  labelStyle: TextStyle(
                    color: Colors.black, //<-- SEE HERE
                  ),

                  
                ),
              ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () { },
              
        child: const Text('Save Changes'),
        style: ElevatedButton.styleFrom(
            
            textStyle: const TextStyle(
                color: Colors.white,
                 fontSize: 17, 
                 fontWeight: FontWeight.bold),
          ),
        
      ),
          ),



        ]),
      ),
    );
  }
}