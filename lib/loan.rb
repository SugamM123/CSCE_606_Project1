# frozen_string_literal: true

require 'date'

# checkout records
class Loan
  STATUS_ACTIVE = 'active'
  STATUS_RETURNED = 'returned'

  attr_accessor :bookId, :memberId, :dueDate, :status, :returnDate

  # snake case support
  alias book_id bookId
  alias book_id= bookId=
  alias member_id memberId
  alias member_id= memberId=
  alias due_date dueDate
  alias due_date= dueDate=
  alias return_date returnDate
  alias return_date= returnDate=

  
  def initialize(*args, **kwargs)
    if args.any?
      @bookId = args[0].respond_to?(:id) ? args[0].id : args[0]
      @memberId = args[1].respond_to?(:id) ? args[1].id : args[1]
      @dueDate = args[2]
      @status = args[3] || STATUS_ACTIVE
      @returnDate = args[4]
    else
      # extract ID 
      # if a model instance was passed in, otherwise use raw ID
      book_val = kwargs[:bookId] || kwargs[:book_id] || kwargs[:book]
      @bookId = book_val.respond_to?(:id) ? book_val.id : book_val

      member_val = kwargs[:memberId] || kwargs[:member_id] || kwargs[:member]
      @memberId = member_val.respond_to?(:id) ? member_val.id : member_val

      @dueDate = kwargs[:dueDate] || kwargs[:due_date]
      @status = kwargs[:status] || STATUS_ACTIVE
      @returnDate = kwargs[:returnDate] || kwargs[:return_date]
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
    return false if dueDate.nil?

    date = dueDate.is_a?(Date) ? dueDate : Date.parse(dueDate.to_s)
    current = as_of.is_a?(Date) ? as_of : Date.parse(as_of.to_s)
    current > date
  rescue ArgumentError
    false 
  end

  # return hash format
  def toHash
    {
      'bookId' => bookId,
      'memberId' => memberId,
      'dueDate' => dueDate.to_s,
      'status' => status,
      'returnDate' => returnDate&.to_s,
      'book_id' => bookId,
      'member_id' => memberId,
      'due_date' => dueDate.to_s,
      'return_date' => returnDate&.to_s
    }
  end
  alias to_h toHash

  # builds loan from hash data
  def self.fromHash(hash)
    return nil unless hash

    new(
      bookId: hash['bookId'] || hash[:bookId] || hash['book_id'] || hash[:book_id],
      memberId: hash['memberId'] || hash[:memberId] || hash['member_id'] || hash[:member_id],
      dueDate: hash['dueDate'] || hash[:dueDate] || hash['due_date'] || hash[:due_date],
      status: hash['status'] || hash[:status] || STATUS_ACTIVE,
      returnDate: hash['returnDate'] || hash[:returnDate] || hash['return_date'] || hash[:return_date]
    )
  end
  singleton_class.alias_method :from_h, :fromHash

  def ==(other)
    other.is_a?(Loan) &&
      bookId == other.bookId &&
      memberId == other.memberId &&
      dueDate.to_s == other.dueDate.to_s &&
      status == other.status &&
      returnDate.to_s == other.returnDate.to_s
  end
end
