module CardCollectionsHelper
  def link_hashtags(text)
    # 해시태그 패턴: #뒤에 글자, 숫자, 밑줄 등이 올 수 있음
    text.gsub(/#(?=[\p{L}\p{N}_]*\p{L})[\p{L}\p{N}_]+/u) do |hashtag|
      name = hashtag[1..].downcase
      link_to(hashtag, hashtag_path(name))
    end.html_safe
  end
end
