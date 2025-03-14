require_relative "boot"

require "rails/all"

require 'redis'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FundooNotes
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    require 'dotenv/rails' if defined?(Dotenv::Railtie)

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # ✅ Corrected Redis Cache Configuration
    config.cache_store = :redis_store, "redis://localhost:6389/0/cache", { expires_in: 90.minutes }

    # ✅ Corrected Session Store
    config.session_store :cache_store, key: "_your_app_session", expire_after: 1.day
    config.time_zone = 'Asia/Kolkata'
    config.active_record.default_timezone = :local

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
