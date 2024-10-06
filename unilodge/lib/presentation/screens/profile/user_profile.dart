import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 350,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF636464).withOpacity(0.15),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xff2E3E4A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFFFFFFF),
                        size: 36,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 350,
            height: 295,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF636464).withOpacity(0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.help,
                    color: AppColors.textColor,
                  ),
                  title: const Text('Help Center'),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textColor, size: 20,),
                  onTap: () {
                    context.go("/help-center");
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.privacy_tip,
                    color: AppColors.textColor,
                  ),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textColor, size: 20,),
                  onTap: () {
                    context.go("/settings");
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.lock,
                    color: AppColors.textColor,
                  ),
                  title: const Text('Terms of Use'),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textColor, size: 20,),
                  onTap: () {
                    context.go("/settings");
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: AppColors.textColor,
                  ),
                  title: const Text('Reviews'),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textColor, size: 20,),
                  onTap: () {
                  
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: AppColors.textColor,
                  ),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textColor, size: 20,),
                  onTap: () {
                    context.go("/settings");
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 130,
            width: 350,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                  Color.fromARGB(255, 252, 225, 225),
                  Color.fromARGB(255, 236, 174, 174),
                  Color.fromARGB(255, 252, 132, 132),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF636464).withOpacity(0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 10.0),
                          child: Text(
                            "Need a place to stay?",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xff2E3E4A),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Find your accommodation and book now!",
                            style: TextStyle(
                              color: Color(0xff454545),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextButton(
                            onPressed: () async {
                              context.go("/listings");
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xfffdfdfd),
                              backgroundColor: const Color(0xff2E3E4A),
                              minimumSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Book now"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 6),
                    child: Image.asset(
                      AppImages.findDorm,
                      width: 200,
                      height: 130,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
