require "redis"

module RedisHelper
	def self.shared_instance
		@redis_instance ||= Redis.new(
		   # these REDIS_* constants are defined in .env
		   host: ENV.fetch('REDIS_HOST', '127.0.0.1'),
		   port: ENV.fetch('REDIS_PORT', 6379),
		   db:   ENV.fetch('REDIS_DB', 0)
		)
	end
end
