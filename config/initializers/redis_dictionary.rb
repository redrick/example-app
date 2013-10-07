# initialization of redis store
TRANSLATION_STORE = Redis.new
begin
   TRANSLATION_STORE.ping
rescue Redis::CannotConnectError => e
   puts "Error: Redis is not turned ON ! Please do so with 'redis-server' " 
   exit 1
end
I18n.backend = I18n::Backend::Chain.new(I18n::Backend::KeyValue.new(TRANSLATION_STORE), I18n.backend)
RedisDictionary::Engine.redis = TRANSLATION_STORE

# You can set your available locales
# I18n.available_locales = [:en, :cs]

# default locale
I18n.default_locale = :en
