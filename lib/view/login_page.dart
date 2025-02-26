// class LoginPage extends StatelessWidget {
//   final GoogleAuthService _authService = GoogleAuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // ปุ่ม Login ด้วย Google
//             ElevatedButton.icon(
//               icon: Icon(Icons.login),
//               label: Text('Login with Google'),
//               onPressed: () async {
//                 var userCredential = await _authService.signInWithGoogle();
//                 if (userCredential != null) {
//                   print('Login Success: ${userCredential.user!.email}');
//                 } else {
//                   print('Login Failed');
//                 }
//               },
//             ),

//             SizedBox(height: 20),

//             // ปุ่ม Login ด้วย Email/Password
//             ElevatedButton(
//               child: Text('Login with Email'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => EmailLoginPage()),
//                 );
//               },
//             ),

//             SizedBox(height: 20),

//             // ปุ่ม Register
//             TextButton(
//               child: Text('Create New Account'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
