import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../bloc/app/access_permission/access_permission_bloc.dart';

class MenuGridWidget extends StatelessWidget {
  const MenuGridWidget({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Gudang',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      _buildWarehouseMenu(context),
      const SizedBox(height: 8,),
      const Text(
        'Proyek',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      _buildProjectMenu(context),
      const SizedBox(height: 8,),
      const Text(
        'Utilitas',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      _buildUtilityMenu(context)
    ],
  );
  Widget _buildWarehouseMenu(BuildContext context) {
    final AccessPermissionBloc accessPermission = context.read<AccessPermissionBloc>();
    final List<Widget> items = <Widget>[];

    if (accessPermission.hasAccess('ITEMVENDORRECEPTION', 'view')) {
      items.add(_buildMenuItem(
        asset: 'assets/images/reception_item.png',
        title: 'Penerimaan Barang Vendor',
        onTap: () => context.router.push(const VendorGoodsReceptionRoute()),
      ));
    }

    items.add(_buildMenuItem(
      asset: 'assets/images/item_entrance.png',
      title: 'Persiapan Barang ke Proyek',
      onTap: () => context.router.push(const ListItemEntranceRoute()),
    ));

    if (accessPermission.hasAccess('RETURNITEM', 'update')) {
      items.add(_buildMenuItem(
        asset: 'assets/images/item_return.png',
        title: 'Penerimaan Barang dari Proyek',
        onTap: () => context.router.push(const DetailItemReturnRoute()),
      ));
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4, // Adjust the number of columns as needed
      children: items,
    );
  }

  Widget _buildProjectMenu(BuildContext context) {
    final AccessPermissionBloc  accessPermission = context.read<AccessPermissionBloc>();
    final List<Widget> items = <Widget>[];

    items.add(_buildMenuItem(
      asset: 'assets/images/prepare_item.png',
      title: 'Penerimaan Barang Proyek',
      onTap: () => context.router.push(const ListOnProjectItemRoute()),
    ));

    items.add(_buildMenuItem(
      asset: 'assets/images/item_entrance.png',
      title: 'Pengiriman Barang ke Gudang',
      onTap: () => context.router.push(const ListPrepareReturnItemRoute()),
    ));


    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4, // Adjust the number of columns as needed
      children: items,
    );
  }

  Widget _buildUtilityMenu(BuildContext context) {
    final AccessPermissionBloc accessPermission = context.read<AccessPermissionBloc>();
    final List<Widget> items = <Widget>[];

    if (accessPermission.hasAccess('ITEM', 'view')) {
      items.add(_buildMenuItem(
        asset: 'assets/images/list_item.png',
        title: 'Daftar Barang',
        onTap: () => context.router.push(const ListItemRoute()),
      ));
    }

    if (accessPermission.hasAccess('INSPECTION', 'update')) {
      items.add(_buildMenuItem(
        asset: 'assets/images/inspect_item.png',
        title: 'Inspeksi Barang',
        onTap: () => context.router.push(const ItemInspectionRoute()),
      ));
    }

    if (accessPermission.hasAccess('INSPECTION', 'update')) {
      items.add(_buildMenuItem(
        asset: 'assets/images/status_item.png',
        title: 'Status Barang',
        onTap: () => context.router.push(const ChangeItemStatusRoute()),
      ));
    }

    if (accessPermission.hasAccess('ITEMTEST', 'view')) {
      items.add(_buildMenuItem(
        asset: 'assets/images/test_item.png',
        title: 'Pengujian Barang',
        onTap: () => context.router.push(const ScanTestingRoute()),
      ));
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4, // Adjust the number of columns as needed
      children: items,
    );
  }

  Widget _buildMenuItem({
    required String asset,
    required String title,
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: <Widget>[
        Image.asset(asset, width: 52, height: 52),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 9),
        ),
      ],
    ),
  );
}