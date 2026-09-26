# frozen_string_literal: true

require 'date'

# checkout records
class Loan
  STATUS_ACTIVE = 'active'
  STATUS_RETURNED = 'returned'

  attr_accessor :book_id, :member_id, :due_date, :status, :return_date

  # handles positional and keyword args
  # split his logic into separate helper methods to keep complexity low.
  def initialize(*args, **kwargs)
    if args.any?
      init_from_args(args)
    else
      init_from_kwargs(kwargs)
    end
  end

  private

  # build from positional args
  def init_from_args(args)
    @book_id = extract_id(args[0])
    @member_id = extract_id(args[1])
    @due_date = args[2]
    @status = args[3] || STATUS_ACTIVE
    @return_date = args[4]
  end

  # build from keyword args
  def init_from_kwargs(kwargs)
    @book_id = extract_id(fetch_book_value(kwargs))
    @member_id = extract_id(fetch_member_value(kwargs))
    @due_date = kwargs[:due_date]
    @status = kwargs[:status] || STATUS_ACTIVE
    @return_date = kwargs[:return_date]
  end

  def fetch_book_value(kwargs)
    kwargs[:book_id] || kwargs[:book]
  end

  def fetch_member_value(kwargs)
    kwargs[:member_id] || kwargs[:member]
  end

  # extracts id if model object is passed
  # otherwise uses raw id
  def extract_id(value)
    value.respond_to?(:id) ? value.id : value
  end

  public

  def active?
    status == STATUS_ACTIVE
  end

  def returned?
    status == STATUS_RETURNED
  end

  # checks past due date.
  # upports both Date objects and strings.
  def overdue?(as_of = Date.today)
    return false unless active?
    return false if due_date.nil?

    date = due_date.is_a?(Date) ? due_date : Date.parse(due_date.to_s)
    current = as_of.is_a?(Date) ? as_of : Date.parse(as_of.to_s)
    current > date
  rescue ArgumentError
    false
  end

  # return hash format
  def to_hash
    {
      'book_id' => book_id,
      'member_id' => member_id,
      'due_date' => due_date.to_s,
      'status' => status,
      'return_date' => return_date&.to_s
    }
  end
  alias to_h to_hash

  # builds loan from hash data
  def self.from_hash(hash)
    return nil unless hash

    new(
      book_id: hash['book_id'] || hash[:book_id],
      member_id: hash['member_id'] || hash[:member_id],
      due_date: hash['due_date'] || hash[:due_date],
      status: hash['status'] || hash[:status] || STATUS_ACTIVE,
      return_date: hash['return_date'] || hash[:return_date]
    )
  end
  singleton_class.alias_method :from_h, :from_hash

  def ==(other)
    other.is_a?(Loan) &&
      book_id == other.book_id &&
      member_id == other.member_id &&
      due_date.to_s == other.due_date.to_s &&
      status == other.status &&
      return_date.to_s == other.return_date.to_s
  end
end
