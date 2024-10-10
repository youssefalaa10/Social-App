import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/icon_broken.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccessState) {
          showToast(
            text: "Profile updated successfully",
            state: ToastStates.success,
          );
        }
      },
      builder: (context, state) {
        var cubit = ProfileCubit.get(context);
        var userModel = cubit.userModel;

        nameController.text = userModel?.name ?? '';
        phoneController.text = userModel?.phone ?? '';
        bioController.text = userModel?.bio ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            actions: [
              defaultTextButton(
                function: () {
                  cubit.updateUser(
                    uId: userModel!.uId,
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
                },
                text: 'Update',
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is ProfileLoadingState) const LinearProgressIndicator(),
                  buildProfileImageSection(context, cubit),
                  const SizedBox(height: 20.0),
                  buildProfileForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildProfileImageSection(BuildContext context, ProfileCubit cubit) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CircleAvatar(
              radius: 64.0,
              backgroundImage: cubit.profileImage == null
                  ? NetworkImage(cubit.userModel!.image)
                  : FileImage(cubit.profileImage!) as ImageProvider,
            ),
            IconButton(
              icon: const CircleAvatar(
                radius: 20.0,
                child: Icon(IconBroken.camera, size: 16.0),
              ),
              onPressed: () {
                cubit.getProfileImage();
              },
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              height: 140.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                image: DecorationImage(
                  image: cubit.coverImage == null
                      ? NetworkImage(cubit.userModel!.cover)
                      : FileImage(cubit.coverImage!) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            IconButton(
              icon: const CircleAvatar(
                radius: 20.0,
                child: Icon(IconBroken.camera, size: 16.0),
              ),
              onPressed: () {
                cubit.getCoverImage();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildProfileForm() {
    return Column(
      children: [
        defaultFormField(
          controller: nameController,
          type: TextInputType.name,
          validate: (String? value) {
            if (value!.isEmpty) {
              return 'Name must not be empty';
            }
            return null;
          },
          label: 'Name',
          prefix: IconBroken.user,
        ),
        const SizedBox(height: 10.0),
        defaultFormField(
          controller: bioController,
          type: TextInputType.text,
          validate: (String? value) {
            if (value!.isEmpty) {
              return 'Bio must not be empty';
            }
            return null;
          },
          label: 'Bio',
          prefix: IconBroken.infoCircle,
        ),
        const SizedBox(height: 10.0),
        defaultFormField(
          controller: phoneController,
          type: TextInputType.phone,
          validate: (String? value) {
            if (value!.isEmpty) {
              return 'Phone number must not be empty';
            }
            return null;
          },
          label: 'Phone',
          prefix: IconBroken.call,
        ),
      ],
    );
  }
}
