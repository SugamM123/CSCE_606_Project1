# frozen_string_literal: true

class Member
  attr_accessor :id, :name

  def initialize(*args, **kwargs)
    if args.any?
      @id = args[0]
      @name = args[1]
    else
      @id = kwargs[:id]
      @name = kwargs[:name]
    end
  end

  # member to hash
  def to_hash
    {
      'id' => id,
      'name' => name
    }
  end
  alias to_h to_hash

  # builds member from hash
  def self.from_hash(hash)
    return nil unless hash

    new(
      id: hash['id'] || hash[:id],
      name: hash['name'] || hash[:name]
    )
  end
  singleton_class.alias_method :from_h, :from_hash

  def ==(other)
    other.is_a?(Member) &&
      id == other.id &&
      name == other.name
  end
end
