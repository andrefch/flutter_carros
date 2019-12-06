import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/user.dart';
import 'package:flutter_carros/screens/login_screen.dart';
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
      future: User.load(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return UserAccountsDrawerHeader(
          accountName: Text(snapshot.data?.name ?? ""),
          accountEmail: Text(snapshot.data?.email ?? ""),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data?.imageURL),
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
