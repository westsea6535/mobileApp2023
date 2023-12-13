import 'package:flutter/material.dart';

class Paragraph with ChangeNotifier {
  String _paragraph = 'An important advantage of disclosure, as apposed to more aggressive forms of regulation, it its flexibility and respect for the operation of free markets. Regulatory mandates are blunt words; they tend to neglect diversity and may have serious unintended adverse effects. For example, energy efficiency requirements for applicances may produce goods that work less well or that have characteristics that consumers do not want. Information provision, by contrast, respects freedom of choice. If automobile manufacturers are required to measure and publicize the safety characteristics of cars, potential car purchasers can trade safety concerns against other attributes, such as price and styling. If restaurant customers are informed tof the calories in their meals, those who want to lose weight can make use of the information, leaving those who are unconcerned about calories unaffected. Disclosure does not interfere with, and should even promote, the autonomy (and quality) of individual decision-making.';

  String get paragraph => _paragraph;

  setParagraph(String newParagraph) {
    _paragraph = newParagraph;
    notifyListeners();
  }
}
