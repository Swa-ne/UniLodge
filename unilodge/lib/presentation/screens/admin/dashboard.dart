import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/admin/custom_container.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: const CustomText(
          text: 'Dashboard',
          color: AppColors.primary,
          fontSize: 18,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          CustomContainer(
              icon: Icon(
                Icons.people,
                size: 100,
                color: AppColors.primary,
              ),
              dataTitle: "Users",
              data: "34"),
          GestureDetector(
            onTap: (){
              context.push("/admin-dashboard-listings");
            },
            child: CustomContainer(
                icon: Icon(
                  Icons.home_work,
                  size: 100,
                  color: AppColors.primary,
                ),
                dataTitle: "Listings",
                data: "23"),
          ),
          
        ],
      ),
    );
  }
}
