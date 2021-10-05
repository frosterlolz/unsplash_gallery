import 'package:flutter/material.dart';
import 'package:unsplash_gallery/data_provider.dart';
import 'package:unsplash_gallery/generated/l10n.dart';
import 'package:unsplash_gallery/models/model.dart';
import 'package:unsplash_gallery/widgets/profile_widget.dart';
import 'package:unsplash_gallery/widgets/text_field_widget.dart';

class EditProfilePage extends StatefulWidget {
  final Sponsor user;

  const EditProfilePage({required this.user, Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? myUsername;
  String? myEmail;
  String? myName;
  String? myInstagram;
  String? myTwitter;
  String? myAbout;
  bool isLoading = false;
  bool isChanged = true;
  bool validate = true;

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: _buildAppBar(context)),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                  imagePath: widget.user.profileImage!.large ?? '',
                  isEdit: true,
                  onClicked: () async {}),
              const SizedBox(
                height: 24,
              ),
              TextFieldWidget(
                label: S.of(context).email,
                validate: validate,
                text: widget.user.email ?? '',
                //TODO: check on @
                onChanged: (email) {
                  myEmail = email;
                  setState(() {
                    validate = RegExp(
                            r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
                        .hasMatch(email);
                  });
                },
              ),
              TextFieldWidget(
                label: S.of(context).username,
                text: widget.user.username ?? '',
                onChanged: (userName) {
                  myUsername = userName;
                },
              ),
              TextFieldWidget(
                label: S.of(context).name,
                text: widget.user.name ?? '',
                onChanged: (name) {
                  myName = name;
                },
              ),
              TextFieldWidget(
                label: S.of(context).instagram,
                text: widget.user.instagramUsername!,
                onChanged: (instagram) {
                  myInstagram = instagram;
                },
              ),
              TextFieldWidget(
                label: S.of(context).about,
                text: widget.user.bio!,
                maxLines: 5,
                onChanged: (about) {
                  myAbout = about;
                },
              ),
            ],
          ),
        ),
      );

  Widget _buildAppBar(BuildContext context) => AppBar(
        automaticallyImplyLeading: false,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(S.of(context).cancel),
              ),
              Text(
                // TODO: change this
                widget.user.username ?? 'username Null',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              isLoading
                  ? Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 20,
                      height: 20,
                      child: const CircularProgressIndicator.adaptive())
                  : TextButton(
                      child: Text(S.of(context).save),
                      //TODO: here we must showProgressBar, then save changes, then nav.pop()
                      onPressed: () {
                        _updateProfile();
                      }),
            ]),
        centerTitle: true,
        elevation: 0,
      );

  _updateProfile() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
        isChanged = false;
      });
      Sponsor user = widget.user;
      myUsername = myUsername == null || myUsername!.trim().isEmpty
          ? user.username
          : myUsername;
      myEmail =
          myEmail == null || myEmail!.trim().isEmpty ? user.email : myEmail;
      myName = myName == null || myName!.trim().isEmpty ? user.name : myName;
      List<String> name = myName!.split(' ');

      myInstagram = myInstagram == null || myInstagram!.trim().isEmpty
          ? user.instagramUsername
          : myInstagram;
      myAbout = myAbout == null || myAbout!.trim().isEmpty ? user.bio : myAbout;

      int statusCode = await DataProvider.updateProfile(
          myUsername!, name[0], name.length==2 ? name[1] : '', myEmail!, myAbout!, myInstagram!);

      setState(() {
        isLoading = false;
        statusCode >= 200 && statusCode < 300
            ? isChanged = true
            : isChanged = false;
        if (isChanged) {
          widget.user.email = myEmail;
          widget.user.username = myUsername;
          widget.user.name = myName;
          widget.user.instagramUsername = myInstagram;
          widget.user.bio = myAbout;
          Navigator.pop(context, widget.user);
        }
      });
    }
  }
}
