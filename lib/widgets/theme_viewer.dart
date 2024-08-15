import 'package:flutter/material.dart';

class ThemeViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary),
            child: Text('Theme Colors', style: theme.textTheme.headlineSmall),
          ),
          _buildColorTile('Primary', colorScheme.primary),
          _buildColorTile('OnPrimary', colorScheme.onPrimary),
          _buildColorTile('Secondary', colorScheme.secondary),
          _buildColorTile('OnSecondary', colorScheme.onSecondary),
          _buildColorTile('Surface', colorScheme.surface),
          _buildColorTile('OnSurface', colorScheme.onSurface),
          _buildColorTile('Background', colorScheme.surface),
          _buildColorTile('OnBackground', colorScheme.onSurface),
          _buildColorTile('Error', colorScheme.error),
          _buildColorTile('OnError', colorScheme.onError),
        ],
      ),
    );
  }

  Widget _buildColorTile(String name, Color color) {
    return ListTile(
      title: Text(name),
      trailing: Container(
        width: 40,
        height: 40,
        color: color,
      ),
    );
  }
}
