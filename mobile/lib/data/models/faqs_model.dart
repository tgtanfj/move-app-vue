class FaqsModel {
  final List<FaqModel> faqs;

  FaqsModel({required this.faqs});

  factory FaqsModel.fromJson(List<dynamic> json) {
    if (json.isEmpty) {
      return FaqsModel(faqs: []);
    }
    List<FaqModel> faqsList =
        json.map((faq) => FaqModel.fromJson(faq)).toList();
    return FaqsModel(faqs: faqsList);
  }

  Map<String, dynamic> toJson() {
    return {
      'faqs': faqs.map((faq) => faq.toJson()).toList(),
    };
  }}

class FaqModel {
  final int? id;
  final String? question;
  final String? answer;

  FaqModel({
    this.id,
    this.question,
    this.answer,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }
}
