# frozen_string_literal: true

module HashHelper
  def fetch_key(hash, camel_key, snake_key)
    hash[camel_key.to_s] || hash[camel_key.to_sym] || hash[snake_key.to_s] || hash[snake_key.to_sym]
  end
end
