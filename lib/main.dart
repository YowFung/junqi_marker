import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

enum Camp { orange, blue, green, purple }

const campNameMap = {
  Camp.orange: "橙色阵营",
  Camp.blue: "蓝色阵营",
  Camp.green: "绿色阵营",
  Camp.purple: "紫色阵营",
};

const campColorMap = {
  Camp.orange: Colors.deepOrange,
  Camp.blue: Colors.blue,
  Camp.green: Colors.green,
  Camp.purple: Colors.deepPurple,
};

enum Role { bomb1, bomb2, president, commander, division1, division2, brigadier1, brigadier2, head1, head2,
  battalion1, battalion2, company1, company2, company3, platoon1, platoon2, platoon3,
  soldier1, soldier2, soldier3, mines1, mines2, flag }

const roleNameMap = {
  Role.bomb1: "炸弹",
  Role.bomb2: "炸弹",
  Role.president: "司令",
  Role.commander: "军长",
  Role.division1: "师长",
  Role.division2: "师长",
  Role.brigadier1: "旅长",
  Role.brigadier2: "旅长",
  Role.head1: "团长",
  Role.head2: "团长",
  Role.battalion1: "营长",
  Role.battalion2: "营长",
  Role.company1: "连长",
  Role.company2: "连长",
  Role.company3: "连长",
  Role.platoon1: "排长",
  Role.platoon2: "排长",
  Role.platoon3: "排长",
  Role.soldier1: "工兵",
  Role.soldier2: "工兵",
  Role.soldier3: "工兵",
  Role.mines1: "地雷",
  Role.mines2: "地雷",
  Role.flag: "军旗",
};

enum RoleState { survival, killed, unknown }

void main() {
  runApp(const MaterialApp(
    title: '四国军棋记牌器',
    home: MyHomePage(),
  ));

  doWhenWindowReady(() {
    appWindow.title = "四国军棋记牌器";
    appWindow.alignment = Alignment.center;
    appWindow.minSize = const Size(400, 750);
    appWindow.maxSize = const Size(400, 750);
    appWindow.size = const Size(400, 750);
    appWindow.show();
  });
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Map<Camp, Map<Role, RoleState>> _roleStateDict = {};

  @override
  void initState() {
    super.initState();
    _onReset(false);
  }

  void _onReset([bool updateUI = true]) {
    _roleStateDict.clear();
    for (final camp in Camp.values) {
      if (!_roleStateDict.containsKey(camp)) {
        _roleStateDict[camp] = {};
      }
      for (final role in Role.values) {
        _roleStateDict[camp]![role] = RoleState.survival;
      }
    }
    if (updateUI) {
      setState(() {});
    }
  }

  void _onRolePressed(Camp camp, Role role) {
    final oldRoleState = _roleStateDict[camp]![role]!;
    final newRoleState = [RoleState.killed, RoleState.unknown, RoleState.survival][oldRoleState.index];
    _roleStateDict[camp]![role] = newRoleState;
    setState(() {});
  }

  Widget _buildCampGroup(Camp camp) {
    return Container(
      width: 380,
      height: 150,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(campNameMap[camp]!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: GridView.count(
              crossAxisCount: 6,
              childAspectRatio: 2,
              mainAxisSpacing: 3,
              crossAxisSpacing: 6,
              children: _roleStateDict[camp]!.keys.map((role) {
                final roleState = _roleStateDict[camp]![role]!;
                final color = roleState == RoleState.killed
                    ? Colors.black87
                    : campColorMap[camp]!.withOpacity(roleState == RoleState.survival ? 1.0 : 0.6);
                return MaterialButton(
                  onPressed: () => _onRolePressed(camp, role),
                  color: color,
                  splashColor: Colors.white10,
                  hoverColor: Colors.black12,
                  hoverElevation: 3,
                  highlightColor: Colors.black12,
                  highlightElevation: 5,
                  child: Text(roleNameMap[role]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCampGroup(Camp.purple),
          _buildCampGroup(Camp.blue),
          _buildCampGroup(Camp.orange),
          _buildCampGroup(Camp.green),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              const Text("点击一次角色变黑色，此时表示该角色已阵亡；\n"
                  "第二次点击角色变半透明，此时表示不确定该角色是否阵亡；\n"
                  "第三次点击角色变回原色，此时表示恢复该角色的生存状态；\n"
                  "点击右侧的 “复位” 按钮将恢复所有阵营所有角色的生存状态。",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 9,
                ),
              ),
              Expanded(child: Container()),
              MaterialButton(
                height: 48,
                minWidth: 80,
                onPressed: _onReset,
                color: Colors.blueGrey,
                textColor: Colors.white,
                child: const Text("复位"),
              ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }
}
