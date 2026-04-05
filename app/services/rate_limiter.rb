class RateLimiter
  @@store = {}

  MAX_ATTEMPTS = 5
  WINDOW = 10.minutes

  def initialize(key)
    @key = key
    @@store[@key] ||= { count: 0, expires_at: Time.now + WINDOW }
  end

  def allowed?
    reset_if_needed
    @@store[@key][:count] < MAX_ATTEMPTS
  end

  def increment!
    reset_if_needed
    @@store[@key][:count] += 1
  end

  def remaining
    MAX_ATTEMPTS - @@store[@key][:count]
  end

  private

  def reset_if_needed
    if Time.now > @@store[@key][:expires_at]
      @@store[@key] = { count: 0, expires_at: Time.now + WINDOW }
    end
  end
end
## This is a simple in-memory rate limiter for demonstration purposes. In production, we would want to use below more robust solution like Redis to handle rate limiting across multiple server instances.

# class RateLimiter
#   MAX_ATTEMPTS = 5
#   WINDOW = 10.minutes

#   def initialize(key)
#     @key = "rate_limit:#{key}"
#     @redis = Redis.new(url: ENV["REDIS_URL"])
#   end

#   #########################################
#   # Check if allowed
#   #########################################
#   def allowed?
#     attempts < MAX_ATTEMPTS
#   end

#   #########################################
#   # Increment attempt
#   #########################################
#   def increment!
#     @redis.multi do |multi|
#       multi.incr(@key)
#       multi.expire(@key, WINDOW.to_i)
#     end
#   end

#   #########################################
#   # Remaining attempts
#   #########################################
#   def remaining
#     MAX_ATTEMPTS - attempts
#   end

#   private

#   def attempts
#     @redis.get(@key).to_i
#   end
# end