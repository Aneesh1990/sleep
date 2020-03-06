import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_giant/Screens/Home/home_screen.dart';
import 'package:sleep_giant/blocs/authBloc/auth_bloc.dart';
import 'package:sleep_giant/repositories/user_repository.dart';

import 'Screens/Login/login_page.dart';
import 'blocs/authBloc/auth_event.dart';
import 'blocs/authBloc/auth_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  UserRepository userRepository = UserRepository();
  //<editor-fold desc=" Build Function ">
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(canvasColor: Colors.black45),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) =>
            AuthBloc(userRepository: userRepository)..add(AppStartedEvent()),
        child: App(
          userRepository: userRepository,
        ),
      ),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/root': (context) => LoginPageParent(userRepository: userRepository),
      },
    );
  }
  //</editor-fold>
}

class App extends StatelessWidget {
  UserRepository userRepository;

  App({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
//    return HelpScreen();
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitialState) {
          return SplashPage();
        } else if (state is AuthenticatedState) {
          // return AudioPlayer();
          return HomePageParent(
              user: state.user, userRepository: userRepository);
        } else if (state is UnauthenticatedState) {
          return LoginPageParent(userRepository: userRepository);
        } else {
          return SplashPage();
        }
      },
    );
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/splash_bg.png'),
    );
  }
}
