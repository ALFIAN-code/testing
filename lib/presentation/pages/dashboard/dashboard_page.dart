import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../core/utils/formz.dart';
import '../../../dependency_injection.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../widgets/dashboard/search_bar_card.dart';
import '../../widgets/shared/dialog/confirm_dialog.dart';
import '../../widgets/state/base_ui_state.dart';

import '../../widgets/dashboard/sections/first_sections.dart';
import '../../widgets/dashboard/sections/second_sections.dart';
import '../../widgets/dashboard/user/user_information_widget.dart';
import '../../widgets/dashboard/menu/menu_grid_widget.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocProvider<DashboardBloc>(
    create: (_) {
      final DashboardBloc bloc = DashboardBloc(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      )..initial();
      return bloc;
    },
    child: const _DashboardView(),
  );
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends BaseUiState<_DashboardView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    child: BasicScaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          const BuildHeader(),
          BuildSearchbar(searchController: _searchController),
          const BuildContent(),
        ],
      ),
    ),
  );
}

class BasicScaffold extends StatelessWidget {
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool statusBarIconIsDark;
  final Color? statusBarColor;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? body;
  final Color? backgroundColor;

  const BasicScaffold({
    super.key,
    this.safeAreaTop = false,
    this.safeAreaBottom = true,
    this.statusBarIconIsDark = false,
    this.statusBarColor,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.body,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
      top: safeAreaTop,
      bottom: safeAreaBottom,
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        body: body,
      ),
    );
}

class BuildContent extends StatelessWidget {
  const BuildContent({super.key});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        color: Colors.white,
      ),
      child: RefreshIndicator(
        onRefresh: () => context.read<DashboardBloc>().load(),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Menu Aplikasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              MenuGridWidget(),
              FirstSectionWidget(),
              SecondSectionWidget(),
            ],
          ),
        ),
      ),
    ),
  );
}

class BuildLogoutButton extends StatefulWidget {
  const BuildLogoutButton({super.key});

  @override
  State<BuildLogoutButton> createState() => _BuildLogoutButtonState();
}

class _BuildLogoutButtonState extends BaseUiState<BuildLogoutButton> {
  @override
  Widget build(BuildContext context) =>
      BlocListener<DashboardBloc, DashboardState>(
        listenWhen: (p, c) => p.logoutStatus != c.logoutStatus,
        listener: (BuildContext context, DashboardState state) {
          if (state.logoutStatus.isSuccess) {
            hideLoading();
            context.router.pushAndPopUntil(
              const SplashRoute(),
              predicate: (_) => false,
            );
          } else if (state.logoutStatus.isInProgress) {
            showLoading();
          } else if (state.logoutStatus.isFailure) {
            hideLoading();
            showErrorMessage(state.errorMessage ?? 'Gagal logout');
          }
        },
        child: IconButton(
          onPressed:
              () => showDialog<void>(
                context: context,
                builder:
                    (BuildContext ctx) => ConfirmDialog(
                      title: 'Logout Aplikasi',
                      content: 'Apakah anda yakin untuk logout',
                      onConfirm: () {
                        Navigator.pop(ctx);
                        context.read<DashboardBloc>().logout();
                      },
                      onCancel: () => Navigator.pop(ctx),
                    ),
              ),
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      );
}

class BuildSearchbar extends StatelessWidget {
  const BuildSearchbar({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 20, top: 8),
    child: SearchBarCard(
      controller: searchController,
      onChanged: (String query) {},
    ),
  );
}

class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<DashboardBloc, DashboardState>(
    builder:
        (BuildContext context, DashboardState state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage:
                    (state.imagePath ?? '').isEmpty
                        ? const AssetImage('assets/images/default_profile.jpg')
                            as ImageProvider
                        : NetworkImage(state.imagePath!),
              ),
              const SizedBox(width: 16),
              const Expanded(child: UserInformationWidget()),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: Colors.white),
              ),
              const BuildLogoutButton(),
            ],
          ),
        ),
  );
}
