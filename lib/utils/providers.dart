import 'package:hicoder/view_models/auth/login_view_model.dart';
import 'package:hicoder/view_models/auth/register_view_model.dart';
import 'package:hicoder/view_models/post/posts_view_model.dart';
import 'package:hicoder/view_models/theme/theme_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../view_models/user/user_view_model.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => RegisterViewModel()),
  ChangeNotifierProvider(create: (_) => LoginViewModel()),
  ChangeNotifierProvider(create: (_) => PostsViewModel()),
  // ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
  // ChangeNotifierProvider(create: (_) => ConversationViewModel()),
  // ChangeNotifierProvider(create: (_) => StatusViewModel()),
  ChangeNotifierProvider(create: (_) => UserViewModel()),
  ChangeNotifierProvider(create: (_) => ThemeProvider()),
];
