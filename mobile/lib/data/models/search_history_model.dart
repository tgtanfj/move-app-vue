class SearchHistoryModel {
  final String? content;

  SearchHistoryModel({
    this.content,
  });

  SearchHistoryModel copyWith({
    String? content,
  }) {
    return SearchHistoryModel(
      content: content ?? this.content,
    );
  }

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      content: json['content'] is String? ? json['content'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}
