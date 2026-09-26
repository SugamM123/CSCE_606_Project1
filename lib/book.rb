# frozen_string_literal: true

require_relative 'hash_helper'

class Book
  extend HashHelper
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

  def checked_out?
    status == STATUS_CHECKED_OUT
  end
  alias checked_out? checked_out?

  # isbn and id support
  alias isbn id
  alias isbn= id=

  # hash formattng
  def to_hash
    {
      'id' => id,
      'title' => title,
      'author' => author,
      'status' => status
    }
  end
  alias to_h to_hash

  ## build instance
  def self.from_hash(hash)
    return nil unless hash

    new(
      id: fetch_key(hash, 'id', 'isbn'),
      title: fetch_key(hash, 'title', 'title'),
      author: fetch_key(hash, 'author', 'author'),
      status: fetch_key(hash, 'status', 'status') || STATUS_AVAILABLE
    )
  end
  singleton_class.alias_method :from_h, :from_hash

  # comparing book attributes
  def ==(other)
    other.is_a?(Book) &&
      id == other.id &&
      title == other.title &&
      author == other.author &&
      status == other.status
  end
end
