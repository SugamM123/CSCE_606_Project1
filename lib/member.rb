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
  def toHash
    {
      'id' => id,
      'name' => name
    }
  end
  alias to_h toHash


  # builds member from hash
  def self.fromHash(hash)
    return nil unless hash

    new(
      id: hash['id'] || hash[:id],
      name: hash['name'] || hash[:name]
    )
  end
  singleton_class.alias_method :from_h, :fromHash


  def ==(other)
    other.is_a?(Member) &&
      id == other.id &&
      name == other.name
  end
end
