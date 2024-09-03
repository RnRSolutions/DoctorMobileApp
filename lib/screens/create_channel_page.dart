import 'package:flutter/material.dart';

class CreateChannelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Channel'),
      ),
      body: Center(
        child: Text('Create a new video chat channel here.'),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class CreateChannelPage extends StatefulWidget {
//   const CreateChannelPage({super.key});
//
//   @override
//   State<CreateChannelPage> createState() => _CreateChannelPageState();
// }
//
// class _CreateChannelPageState extends State<CreateChannelPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }