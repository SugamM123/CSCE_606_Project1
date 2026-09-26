# frozen_string_literal: true

require 'date'

# checkout records
class Loan
  STATUS_ACTIVE = 'active'
  STATUS_RETURNED = 'returned'

  attr_accessor :book_id, :member_id, :due_date, :status, :return_date
  alias book_id= book_id=
  alias member_id member_id
  alias member_id= member_id=
  alias due_date due_date
  alias due_date= due_date=
  alias return_date return_date
  alias return_date= return_date=

  def initialize(*args, **kwargs)
    if args.any?
      @book_id = args[0].respond_to?(:id) ? args[0].id : args[0]
      @member_id = args[1].respond_to?(:id) ? args[1].id : args[1]
      @due_date = args[2]
      @status = args[3] || STATUS_ACTIVE
      @return_date = args[4]
    else
      # extract ID
      # if a model instance was passed in, otherwise use raw ID
      book_val = kwargs[:book_id] || kwargs[:book_id] || kwargs[:book]
      @book_id = book_val.respond_to?(:id) ? book_val.id : book_val

      member_val = kwargs[:member_id] || kwargs[:member_id] || kwargs[:member]
      @member_id = member_val.respond_to?(:id) ? member_val.id : member_val

      @due_date = kwargs[:due_date] || kwargs[:due_date]
      @status = kwargs[:status] || STATUS_ACTIVE
      @return_date = kwargs[:return_date] || kwargs[:return_date]
    end
  end

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
      'status' => status,
      'book_id' => book_id,
      'member_id' => member_id,
      'due_date' => due_date.to_s,
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
