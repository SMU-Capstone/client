import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/loading.jpeg'),
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.6), BlendMode.modulate),
        ),
      ),
      child: Center(
        child: Text('Loading...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            letterSpacing: 5,
            fontWeight: FontWeight.w700,
          ),
        )
      ),
    );
  }
}