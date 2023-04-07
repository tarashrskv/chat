import 'author.dart';
import 'question.dart';

class ThematicChat {
  final String uuid;
  final Author author;
  //final String? createError;
  // final bool simplifyForm;
  final String title;
  final List<Question>? questions;
  final String description;
  //final int tgPostId;
  final bool? adultOnly;
  final bool? restrictNewbies;

  ThematicChat({
    required this.uuid,
    required this.title,
    required this.description,
    required this.author,
    //this.createError,
    // required this.simplifyForm,
    this.questions,
    //required this.tgPostId,
    this.adultOnly,
    this.restrictNewbies,
  });

  factory ThematicChat.fromJson(Map<String, dynamic> json) {
    return ThematicChat(
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      author: Author.fromJson(json['author']),
      //createError: json['createError'],
      //simplifyForm: json['simplifyForm'],
      questions: json['questions'] == null
          ? null
          : List<Question>.from(json['questions'].map((q) => Question.fromJson(q))),
      //tgPostId: json['tgPostId'],
      adultOnly: json['adultOnly'],
      restrictNewbies: json['restrictNewbies'],
    );
  }
}