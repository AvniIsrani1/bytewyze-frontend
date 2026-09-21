import 'package:flutter/material.dart';


class CreateaccTest extends StatelessWidget {
  const CreateaccTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar automatically shows a back arrow whenever there's a page
      // underneath this one on the stack, and that arrow already calls
      // Navigator.pop(context) for you — no extra code needed for "Back".
      appBar: AppBar(
        title: const Text("Create Account"),
        automaticallyImplyLeading: false, // Removes the automatic back arrow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // back logic
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text('This is the create account test page >:p'),
      ),
    );
  }
} 
