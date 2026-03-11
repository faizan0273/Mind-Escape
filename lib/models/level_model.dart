/*
---------------------------------------------------
Project:        Cipher Escape
Date:           March 10, 2026
Author:         Muhammad Faizan
---------------------------------------------------

Description:    Data models for a game level, including LevelModel
                and ChoiceModel. Parsed from the JSON level asset files.

---------------------------------------------------
*/

class ChoiceModel {
  final int id;
  final String text;
  final bool isCorrect;

  const ChoiceModel({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory ChoiceModel.fromJson(Map<String, dynamic> json) {
    return ChoiceModel(
      id: json['id'] as int,
      text: json['text'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'is_correct': isCorrect,
      };
}

class LevelModel {
  final int id;
  final String difficulty;
  final String title;
  final String story;
  final String sender;
  final String senderIcon;
  final String cipherType;
  final String cipherLabel;
  final String encryptedMessage;
  final String decodedMessage;
  final bool isTimed;
  final int? timeLimit;
  final bool isMultiLayer;
  final List<ChoiceModel> choices;
  final String deathMessage;
  final String successMessage;
  final String hint1;
  final String hint2;
  final String hint3;
  final int rewardCoins;
  final int rewardXp;

  const LevelModel({
    required this.id,
    required this.difficulty,
    required this.title,
    required this.story,
    required this.sender,
    required this.senderIcon,
    required this.cipherType,
    required this.cipherLabel,
    required this.encryptedMessage,
    required this.decodedMessage,
    required this.isTimed,
    this.timeLimit,
    required this.isMultiLayer,
    required this.choices,
    required this.deathMessage,
    required this.successMessage,
    required this.hint1,
    required this.hint2,
    required this.hint3,
    required this.rewardCoins,
    required this.rewardXp,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] as int,
      difficulty: json['difficulty'] as String,
      title: json['title'] as String,
      story: json['story'] as String,
      sender: json['sender'] as String,
      senderIcon: json['sender_icon'] as String,
      cipherType: json['cipher_type'] as String,
      cipherLabel: json['cipher_label'] as String,
      encryptedMessage: json['encrypted_message'] as String,
      decodedMessage: json['decoded_message'] as String,
      isTimed: json['is_timed'] as bool,
      timeLimit: json['time_limit'] as int?,
      isMultiLayer: json['is_multi_layer'] as bool,
      choices: (json['choices'] as List)
          .map((c) => ChoiceModel.fromJson(c as Map<String, dynamic>))
          .toList(),
      deathMessage: json['death_message'] as String,
      successMessage: json['success_message'] as String,
      hint1: json['hint1'] as String,
      hint2: json['hint2'] as String,
      hint3: json['hint3'] as String,
      rewardCoins: json['reward_coins'] as int,
      rewardXp: json['reward_xp'] as int,
    );
  }

  /// Phase number this level belongs to (1=Easy, 2=Medium, 3=Hard).
  int get phase {
    if (id <= 10) return 1;
    if (id <= 20) return 2;
    return 3;
  }

  ChoiceModel? get correctChoice =>
      choices.where((c) => c.isCorrect).firstOrNull;
}
