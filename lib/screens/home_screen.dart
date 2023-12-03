import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gurucool/models/user.dart';
import 'package:gurucool/states/actions_state.dart';
import 'package:gurucool/states/connection_state.dart';
import 'package:gurucool/states/nav_state.dart';
import 'package:gurucool/states/nav_title_state.dart';
import 'package:gurucool/states/user_state.dart';
import 'package:gurucool/utils/constants.dart';
import 'package:gurucool/utils/repository.dart';
import 'package:gurucool/utils/responsive.dart';
import 'package:gurucool/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pageController = PageController();
  ScaffoldFeatureController? connectionBar;
  String currentTitle = adminSideNav[0].title;
  int last = 0;
  late User user;
  late Repository repository;

  @override
  void initState() {
    user = context.read<UserState>().state!;
    context.read<NavTitleState>().setNavTitle(user.role == 0
        ? adminSideNav[0].title
        : user.role == 1
            ? teacherSideNav[0].title
            : studentSideNav[0].title);
    repository = RepositoryProvider.of<Repository>(context);
    repository.user = user;
    repository.headers = {
      "Content-Type": "application/json",
      "Authorization": user.token,
    };
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet) {
        context.read<AppConnectionState>().setConnection(true);
      } else {
        context.read<AppConnectionState>().setConnection(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppConnectionState, bool>(
      listener: (_, state) {
        if (state) {
          connectionBar?.close();
        } else {
          connectionBar =
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            dismissDirection: DismissDirection.none,
            content: Text("No Internet"),
            backgroundColor: Colors.red,
            duration: Duration(days: 365),
          ));
        }
      },
      child: BlocBuilder<NavState, int>(builder: (navContext, navState) {
        if (navState != -1 && last != navState) {
          switch (user.role) {
            case 0:
              if (!adminSideNav[navState].hasMenu) {
                context.read<ActionsState>().setActions(null);
              }
              break;
            case 1:
              if (!teacherSideNav[navState].hasMenu) {
                context.read<ActionsState>().setActions(null);
              }
              break;
            case 2:
              if (!studentSideNav[navState].hasMenu) {
                context.read<ActionsState>().setActions(null);
              }
              break;
          }
          last = navState;
          context.read<NavTitleState>().setNavTitle(user.role == 0
              ? adminSideNav[navState].title
              : user.role == 1
                  ? teacherSideNav[navState].title
                  : studentSideNav[navState].title);
        }
        return BlocBuilder<NavTitleState, String>(
            builder: (titleContext, navTitleState) {
          return BlocBuilder<ActionsState, List<Widget>?>(
              builder: (actionContext, actionState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: Responsive.isSmall(context)
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: primaryColor,
                      leading: navState == -1
                          ? IconButton(
                              onPressed: () {
                                context.read<NavState>().setNav(last);
                              },
                              icon: const Icon(Icons.arrow_back))
                          : null,
                      titleSpacing: 0,
                      title: Text(navTitleState),
                      actions: actionState,
                    )
                  : null,
              drawer: CustomDrawer(hide: true, prev: last),
              body: Row(
                children: [
                  !Responsive.isSmall(context)
                      ? CustomDrawer(
                          hide: false,
                          prev: last,
                        )
                      : const FittedBox(),
                  Expanded(
                    child: Container(
                        padding: !Responsive.isSmall(context)
                            ? const EdgeInsets.all(25)
                            : const EdgeInsets.all(0),
                        color: secondaryColor,
                        child: Column(
                          children: [
                            !Responsive.isSmall(context)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            navTitleState,
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 36,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: actionState ?? [],
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : const FittedBox(),
                            !Responsive.isSmall(context)
                                ? const SizedBox(
                                    height: 40,
                                  )
                                : const FittedBox(),
                            BlocListener<NavState, int>(
                              listener: (blocContext, navState) {
                                if (pageController.hasClients &&
                                    navState != -1 &&
                                    navState != -2) {
                                  pageController.animateToPage(navState,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.ease);
                                }
                              },
                              child: Expanded(
                                child: PageView(
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: pageController,
                                  children: user.role == 0
                                      ? adminSideScreens
                                      : user.role == 1
                                          ? teacherSideScreens
                                          : studentSideScreens,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            );
          });
        });
      }),
    );
  }
}
