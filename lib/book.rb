# frozen_string_literal: true

# Books in library
class Book
  STATUS_AVAILABLE = 'available'
  STATUS_CHECKED_OUT = 'checked_out'

  attr_accessor :id, :title, :author, :status

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

  alias isbn id
  alias isbn= id=

  def toHash
    {
      'id' => id,
      'title' => title,
      'author' => author,
      'status' => status
    }
  end
  alias to_h toHash

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

  def ==(other)
    other.is_a?(Book) &&
      id == other.id &&
      title == other.title &&
      author == other.author &&
      status == other.status
  end
end
