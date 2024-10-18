import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_event.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_state.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/admin/custom_container.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AdminBloc _adminBloc;

  @override
  void initState() {
    super.initState();
    _adminBloc = BlocProvider.of<AdminBloc>(context);
    _adminBloc.add(FetchListings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminListingState>(
      builder: (context, state) {
        int listingCount = 0;

        if (state is ListingLoaded) {
          listingCount = state.listings.length;
        }

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
              const SizedBox(
                height: 20,
              ),
              CustomContainer(
                  icon: const Icon(
                    Icons.people,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  dataTitle: "Users",
                  data: "34"),
              GestureDetector(
                onTap: () {
                  context.push("/admin-dashboard-listings");
                },
                child: CustomContainer(
                    icon: const Icon(
                      Icons.home_work,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    dataTitle: "Listings",
                    data: listingCount.toString()),
              ),
            ],
          ),
        );
      },
    );
  }
}
