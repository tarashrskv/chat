import 'author.dart';
import 'question.dart';

class TopicChat {
  final Author author;
  //final String? createError;
  // final bool simplifyForm;
  final String? title;
  final List<Question>? questions;
  final String? description;
  //final String uuid;
  //final int tgPostId;
  final bool? adultOnly;
  //final bool? restrictNewbies;

  TopicChat({
    required this.author,
    //this.createError,
    // required this.simplifyForm,
    this.title,
    this.questions,
    this.description,
    //required this.uuid,
    //required this.tgPostId,
    this.adultOnly,
    //this.restrictNewbies,
  });

  factory TopicChat.fromJson(Map<String, dynamic> json) {
    return TopicChat(
      author: Author.fromJson(json['author']),
      //createError: json['createError'],
      //simplifyForm: json['simplifyForm'],
      title: json['title'],
      questions: json['questions'] == null
          ? null
          : List<Question>.from(
          json['questions'].map((x) => Question.fromJson(x))),
      description: json['description'],
     // uuid: json['uuid'],
      //tgPostId: json['tgPostId'],
      adultOnly: json['adultOnly'],
      //restrictNewbies: json['restrictNewbies'],
    );
  }
}