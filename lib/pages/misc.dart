import 'package:flutter/material.dart';

Widget InfoRow(
    {IconData? icon,
    required String text,
    double size = 14.0,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    children: [
      if (icon != null)
        Icon(icon, color: color, size: size), // Include icon if provided
      SizedBox(width: icon != null ? 8.0 : 0), // Add spacing if icon is present
      Text(
        text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    ],
  );
}

Widget UserProfileRow(
    {String? picture, // Nullable profile picture URL
    required String username, // Username is required
    double pictureSize = 40.0, // Default size for the profile picture
    double fontSize = 16.0, // Default font size for the username
    Color textColor = Colors.black, // Default text color
    FontWeight fontWeight = FontWeight.normal, // Default font weight
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    children: [
      SizedBox(height: 8.0),
      if (picture != null)
        CircleAvatar(
            radius: pictureSize / 2, backgroundImage: AssetImage(picture)),
      if (picture != null)
        SizedBox(width: 8.0), // Spacing if profile picture exists
      Text(
        username,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
      SizedBox(height: 8.0),
    ],
  );
}
