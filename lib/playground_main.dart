import 'package:flutter/material.dart';

import 'signin_test.dart';
import 'createAcc_test.dart';

// A separate entry point from your real app. Run this one with:
//   flutter run -t lib/playground_main.dart
// Your real lib/main.dart is never touched by anything in here.
void main() {
  runApp(const PlaygroundApp());
}

class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playground',
      home: const PlaygroundHub(),
    );
  }
}

// The "hub" page: no content of its own besides buttons. Each button pushes
// straight to one specific page file — add a new button + import for every
// new page file you create.
class PlaygroundHub extends StatelessWidget {
  const PlaygroundHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: const Text("Playground"),
        automaticallyImplyLeading: false, // Removes the automatic back arrow
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(          // SIGN IN PAGE
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInTestPage(),
                  ),
                );
              },
              child: const Text('Sign In')
            ),
            ElevatedButton(            //CREATE ACC PAGE
             onPressed:() {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateaccTest(),
                ),
               );
             },
             child: const Text("Sign Up") 
            ),
          ],
        ),
        
      ),
    );
  }
}