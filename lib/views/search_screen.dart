import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location_model.dart';
import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import 'widgets/location_tile.dart';
import 'widgets/state_message.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(LocationModel location) {
    final navigator = Navigator.of(context);
    context.read<LocationViewModel>().addToHistory(location);
    context.read<WeatherViewModel>().selectLocation(location);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocationViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Lokasi')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controller,
                    builder: (context, value, _) => TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      onChanged: vm.onQueryChanged,
                      onSubmitted: vm.search,
                      decoration: InputDecoration(
                        hintText: 'Cari nama kota…',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: value.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Hapus',
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _controller.clear();
                                  vm.onQueryChanged('');
                                },
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: _buildContent(context, vm)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LocationViewModel vm) {
    switch (vm.status) {
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.error:
        return StateMessage(
          icon: Icons.cloud_off,
          title: 'Pencarian gagal',
          message: vm.errorMessage,
          actionLabel: 'Coba lagi',
          onAction: () => vm.search(vm.query),
        );
      case SearchStatus.empty:
        return const StateMessage(
          icon: Icons.location_off_outlined,
          title: 'Kota tidak ditemukan',
          message: 'Coba gunakan kata kunci lain.',
        );
      case SearchStatus.success:
        return _LocationList(
          locations: vm.results,
          vm: vm,
          onSelect: _select,
        );
      case SearchStatus.idle:
        return _SavedLists(vm: vm, onSelect: _select);
    }
  }
}

class _LocationList extends StatelessWidget {
  const _LocationList({
    required this.locations,
    required this.vm,
    required this.onSelect,
  });

  final List<LocationModel> locations;
  final LocationViewModel vm;
  final ValueChanged<LocationModel> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, i) {
        final loc = locations[i];
        return LocationTile(
          location: loc,
          isFavorite: vm.isFavorite(loc),
          onTap: () => onSelect(loc),
          onToggleFavorite: () => vm.toggleFavorite(loc),
        );
      },
    );
  }
}

class _SavedLists extends StatelessWidget {
  const _SavedLists({required this.vm, required this.onSelect});

  final LocationViewModel vm;
  final ValueChanged<LocationModel> onSelect;

  @override
  Widget build(BuildContext context) {
    if (vm.favorites.isEmpty && vm.history.isEmpty) {
      return const StateMessage(
        icon: Icons.travel_explore,
        title: 'Cari kota',
        message: 'Ketik nama kota untuk melihat cuacanya.',
      );
    }

    final textTheme = Theme.of(context).textTheme;
    return ListView(
      children: [
        if (vm.favorites.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Favorit', style: textTheme.titleMedium),
          ),
          for (final loc in vm.favorites)
            LocationTile(
              location: loc,
              isFavorite: true,
              onTap: () => onSelect(loc),
              onToggleFavorite: () => vm.toggleFavorite(loc),
            ),
        ],
        if (vm.history.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text('Riwayat pencarian',
                      style: textTheme.titleMedium),
                ),
                TextButton(
                  onPressed: vm.clearHistory,
                  child: const Text('Hapus'),
                ),
              ],
            ),
          ),
          for (final loc in vm.history)
            LocationTile(
              location: loc,
              leadingIcon: Icons.history,
              isFavorite: vm.isFavorite(loc),
              onTap: () => onSelect(loc),
              onToggleFavorite: () => vm.toggleFavorite(loc),
            ),
        ],
      ],
    );
  }
}
