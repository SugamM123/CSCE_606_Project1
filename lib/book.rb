# frozen_string_literal: true


class Book
  STATUS_AVAILABLE = 'available'
  STATUS_CHECKED_OUT = 'checked_out'

  attr_accessor :id, :title, :author, :status

  # :id or :isbn support
  def initialize(*args, **kwargs)
    if args.any?
      @id = args[0]
      @title = args[1]
      @author = args[2]
      @status = args[3] || STATUS_AVAILABLE
    else
      @id = kwargs[:id] || kwargs[:isbn]
      @title = kwargs[:title]
      @author = kwargs[:author]
      @status = kwargs[:status] || STATUS_AVAILABLE
    end
  end

  def available?
    status == STATUS_AVAILABLE
  end

  def checkedOut?
    status == STATUS_CHECKED_OUT
  end
  alias checked_out? checkedOut?

  # isbn and id support
  alias isbn id
  alias isbn= id=

  # hash formattng
  def toHash
    {
      'id' => id,
      'title' => title,
      'author' => author,
      'status' => status
    }
  end
  alias to_h toHash

  

  ## build instance
  def self.fromHash(hash)
    return nil unless hash

    new(
      id: hash['id'] || hash[:id] || hash['isbn'] || hash[:isbn],
      title: hash['title'] || hash[:title],
      author: hash['author'] || hash[:author],
      status: hash['status'] || hash[:status] || STATUS_AVAILABLE
    )
  end
  singleton_class.alias_method :from_h, :fromHash

  # comparing book attributes
  def ==(other)
    other.is_a?(Book) &&
      id == other.id &&
      title == other.title &&
      author == other.author &&
      status == other.status
  end
end
