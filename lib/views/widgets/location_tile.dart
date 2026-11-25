import 'package:flutter/material.dart';

import '../../models/location_model.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({
    super.key,
    required this.location,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
    this.leadingIcon = Icons.location_on_outlined,
  });

  final LocationModel location;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final IconData leadingIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(location.name),
      subtitle: location.subtitle.isEmpty ? null : Text(location.subtitle),
      trailing: IconButton(
        tooltip: isFavorite ? 'Hapus dari favorit' : 'Simpan ke favorit',
        icon: Icon(isFavorite ? Icons.star : Icons.star_border),
        color: isFavorite ? Colors.amber.shade700 : null,
        onPressed: onToggleFavorite,
      ),
      onTap: onTap,
    );
  }
}
