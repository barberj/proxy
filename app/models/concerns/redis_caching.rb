module RedisCaching
  extend ActiveSupport::Concern

  def redis_key(part)
    raise "#{self.class} must be commited before it can cache" unless self.persisted?
    "#{self.class.name}_#{self.id}_#{part}"
  end

  def expire_redis(key_part, expiration)
    $redis.expire(redis_key(key_part), expiration)
  end

  def del_redis(key_part)
    $redis.del(redis_key(key_part))

    nil
  end

  def update_redis(key_part, data, expiration=nil)
    if data
      $redis.set(redis_key(key_part), JSON.dump(data))
      expire_redis(key_part, expiration) if expiration

      from_redis(key_part)
    else
      del_redis(key_part)
    end
  end

  def from_redis(key_part, expiration=nil, &block)
    (
      JSON.load($redis.get(redis_key(key_part)))
    ) || (
      if block
        update_redis(
          key_part,
          block.call,
          expiration
        )
      end
    )
  end
end
