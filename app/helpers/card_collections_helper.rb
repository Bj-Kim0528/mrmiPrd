module CardCollectionsHelper
  def link_hashtags(text)
    # 해시태그 패턴: #뒤에 글자, 숫자, 밑줄 등이 올 수 있음
    text.gsub(/#([\p{L}\p{N}_]+)/u) do |hashtag|
      hashtag_name = $1.downcase
      # hashtag_path는 라우트에서 '/hashtags/:name'으로 설정되어 있다고 가정
      link_to(hashtag, hashtag_path(hashtag_name))
    end.html_safe
  end
end
