import 'package:crud_app/pages/add.dart';
import 'package:crud_app/pages/favorites.dart';
import 'package:crud_app/pages/lists.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xff110b1f),
        appBar: AppBar(
          title: const Text('Marvin Books'),
          automaticallyImplyLeading: false,
          actions: <Widget> [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => const AddScreen())));
                },
                child: const Icon(Icons.add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Auth().signOut().then((value) {
              Navigator.pushReplacementNamed(context, '/logout');
            });
                },
                child: const Icon(Icons.logout),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff524f5e)
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  labelColor: const Color(0xffa19fa6),
                  dividerColor: const Color(0xffa19fa6),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.book, color: Color(0xffa19fa6),),
                    ),
                    Tab(
                      icon: Icon(Icons.favorite, color: Color(0xffa19fa6),),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              const Expanded(child: TabBarView(
                children: [
                  ListScreen(),
                  FavoriteScreen()
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}