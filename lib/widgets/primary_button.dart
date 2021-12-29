import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTab;
  final String title;

  const PrimaryButton({
    Key? key,
    required this.title,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(this.title),
        ),
        onPressed: this.onTab,
        style: ButtonStyle(
          // minimumSize: Size(double.infinity, 30),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return Colors.black;
              return Colors.black; // Use the component's default.
            },
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
    );
  }
}
