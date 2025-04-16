namespace :hashtags do
  desc "Delete unused hashtags in development (older than 1 minute)"
  task clear_unused_dev: :environment do
    old_hashtags = Hashtag.where("created_at < ?", 1.minute.ago)
    puts "Found #{old_hashtags.count} hashtags older than 1 minute in development."

    old_hashtags.find_each do |hashtag|
      if hashtag.card_collections.exists? || hashtag.bookmarks.exists?
        puts "Skipping hashtag '#{hashtag.name}' because it's in use or bookmarked."
      else
        hashtag.destroy
        puts "Deleted hashtag '#{hashtag.name}'."
      end
    end
  end

  desc "Delete unused hashtags in production (older than 2 days)"
  task clear_unused_prod: :environment do
    old_hashtags = Hashtag.where("created_at < ?", 2.days.ago)
    puts "Found #{old_hashtags.count} hashtags older than 2 days in production."

    old_hashtags.find_each do |hashtag|
      if hashtag.card_collections.exists? || hashtag.bookmarks.exists?
        puts "Skipping hashtag '#{hashtag.name}' because it's in use or bookmarked."
      else
        hashtag.destroy
        puts "Deleted hashtag '#{hashtag.name}'."
      end
    end
  end
end