import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/user.dart';
import 'package:flutter_carros/screens/login_screen.dart';
import 'package:flutter_carros/service/firebase_service.dart';
import 'package:flutter_carros/util/navigator_util.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            _createHeader(),
            _createItem(
              context: context,
              startIconData: Icons.favorite,
              title: "Favoritos",
              subtitle: "Exibe a listagem de favoritos",
              endIconData: Icons.arrow_forward,
              onTap: () {},
            ),
            _createItem(
              context: context,
              startIconData: Icons.help,
              title: "Ajuda",
              subtitle: "Exibe os dados de ajuda do app",
              endIconData: Icons.arrow_forward,
              onTap: () {},
            ),
            _createItem(
              context: context,
              startIconData: Icons.exit_to_app,
              title: "Sair",
              onTap: () {
                User.clear();
                FirebaseService().logout();
                pushScreen(context, LoginScreen(), replace: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createHeader() {
    return FutureBuilder(
      future: FirebaseService().currentUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return UserAccountsDrawerHeader(
          accountName: Text(snapshot.data?.name ?? ""),
          accountEmail: Text(snapshot.data?.email ?? ""),
          currentAccountPicture: snapshot.data?.imageURL != null
              ? CachedNetworkImage(
                  imageUrl: snapshot.data?.imageURL ?? "",
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundImage: image,
                  ),
                  placeholder: (context, url) => const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/placeholder_user.png'),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  },
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/placeholder_user.png'),
                  ),
                )
              : const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/placeholder_user.png'),
                ),
        );
      },
    );
  }

  Widget _createItem(
      {@required BuildContext context,
      @required IconData startIconData,
      @required String title,
      String subtitle,
      IconData endIconData,
      Function onTap}) {
    return ListTile(
      leading: Icon(startIconData),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Icon(endIconData),
      onTap: () {
        popScreen(context);
        onTap();
      },
    );
  }
}
