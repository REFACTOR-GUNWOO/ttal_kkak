import 'dart:math';

import 'package:ttal_kkak/repositories/display_message_repository.dart';

class DisplayMessageDto {
  final int? id;
  final String title;
  final String description;
  final bool showAddClothesButton;
  final String addClothesDescription;
  final String iconUrl;
  final ClosetAnalysisType analysisType;

  DisplayMessageDto({
    this.id,
    required this.title,
    required this.description,
    this.showAddClothesButton = true,
    required this.analysisType,
    required this.addClothesDescription,
    required this.iconUrl,
  });

  static DisplayMessageDto fromDisplayMessage(DisplayMessage displayMessage) {
    return DisplayMessageDto(
      id: displayMessage.id,
      title: displayMessage.title,
      description: displayMessage.description,
      showAddClothesButton: displayMessage.showAddClothesButton,
      analysisType: displayMessage.analysisType,
      addClothesDescription: displayMessage.addClothesDescriptions[
          Random().nextInt(displayMessage.addClothesDescriptions.length)],
      iconUrl: displayMessage.iconUrl,
    );
  }
}
