require File.expand_path('../../config/environment', __FILE__)

if Rails.env.production?
  set :environment, 'production'
  every 2.days, at: '12:00 am' do
    rake "hashtags:clear_unused_prod"
  end
else
  set :environment, 'development'
  every 1.minute do
    rake "hashtags:clear_unused_dev"
  end
end