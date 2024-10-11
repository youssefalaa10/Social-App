import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social/shared/styles/icon_broken.dart';

import '../../models/user_model.dart';
import '../Auth/login/login_screen.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileErrorState) {
          print("Error loading profile: ${state.error}");
        }
      },
      builder: (context, state) {
        var cubit = ProfileCubit.get(context); // Access cubit through BlocProvider
        var userModel = cubit.userModel;

        // Ensure to load user data here if not loaded already
        if (userModel == null) {
          cubit.getUserData(FirebaseAuth.instance.currentUser!.uid); // Use current user's ID
        }

        return userModel != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    buildProfileHeader(context, userModel),
                    buildProfileStats(context),
                    buildActions(context, cubit),
                    const Spacer(),
                    buildSignOutButton(context),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  // Build the Profile Header with User's Image and Cover
  Widget buildProfileHeader(BuildContext context, SocialUserModel userModel) {
    return SizedBox(
      height: 190.0,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Container(
              height: 140.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(userModel.cover),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          CircleAvatar(
            radius: 64.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: 60.0,
              backgroundImage: NetworkImage(userModel.image),
            ),
          ),
        ],
      ),
    );
  }

  // Build Profile Statistics (Posts, Photos, Followers, Following)
  Widget buildProfileStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          buildStatItem(context, '100', 'Posts'),
          buildStatItem(context, '265', 'Photos'),
          buildStatItem(context, '10k', 'Followers'),
          buildStatItem(context, '64', 'Following'),
        ],
      ),
    );
  }

  // Helper Method to Build an Individual Stat Item (Number + Label)
  Widget buildStatItem(BuildContext context, String count, String label) {
    return Expanded(
      child: InkWell(
        onTap: () {}, // Handle action when user taps on stat item
        child: Column(
          children: [
            Text(count, style: Theme.of(context).textTheme.titleSmall),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  // Build Action Buttons (Change Profile Image, Change Cover Image, Edit Profile)
  Widget buildActions(BuildContext context, ProfileCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              cubit.getProfileImage(); // Trigger the method to pick profile image
            },
            child: const Text('Change Profile Image'),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              cubit.getCoverImage(); // Trigger the method to pick cover image
            },
            child: const Text('Change Cover Image'),
          ),
        ),
        const SizedBox(width: 10.0),
        OutlinedButton(
          onPressed: () {
            // Navigate to Edit Profile Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: cubit, // Pass the cubit via BlocProvider
                  child: EditProfileScreen(),
                ),
              ),
            );
          },
          child: const Icon(IconBroken.edit, size: 16.0),
        ),
      ],
    );
  }

  // Build the Sign Out Button to Log the User Out
  Widget buildSignOutButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: const Text(
        'Sign out',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
