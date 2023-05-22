import 'package:cura_frontend/common/size_config.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../explore_community.dart';

class ExploreNewCommunity extends StatefulWidget {
  const ExploreNewCommunity({Key? key}) : super(key: key);

  @override
  State<ExploreNewCommunity> createState() => _exploreNewCommunityState();
}

class _exploreNewCommunityState extends State<ExploreNewCommunity> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: Column(
        children: [
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/explore_community.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(30)),
                  const Text(
                    'Oops, No Joined Communities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    height: getProportionateScreenHeight(50),
                    margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          getProportionateScreenHeight(25)),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ExploreCommunity();
                        }));
                      },
                      // style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
                      child: const Text(
                        'Explore New Communities',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(100),
          )
        ],
      ),
    );
  }
}
