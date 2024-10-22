import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/data/models/user_profile.dart';

class AdminUserCards extends StatefulWidget {
  final UserProfileModel user;

  const AdminUserCards({super.key, required this.user});

  @override
  State<AdminUserCards> createState() => _AdminUserCardsState();
}

class _AdminUserCardsState extends State<AdminUserCards> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          context.pushReplacement('/admin/user-dorms', extra: widget.user);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.user.profilePictureUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: Text(
                widget.user.fullName,
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
