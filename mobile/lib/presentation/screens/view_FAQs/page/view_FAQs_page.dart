import 'package:flutter/widgets.dart';
import 'package:move_app/presentation/screens/view_FAQs/page/view_FAQs_body.dart';

class ViewFAQsPage extends StatefulWidget {
  const ViewFAQsPage({super.key});

  @override
  State<ViewFAQsPage> createState() => _ViewFAQsPageState();
}

class _ViewFAQsPageState extends State<ViewFAQsPage> {
  @override
  Widget build(BuildContext context) {
    return const ViewFAQsBody();
  }
}