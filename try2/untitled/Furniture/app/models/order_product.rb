class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  STATUSES = %w[In\ processing Sent Cancelled].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :manufacturer_start_date, :manufacturer_end_date, presence: true, if: :dates_present?

  private

  def dates_present?
    manufacturer_start_date.present? || manufacturer_end_date.present?
  end
end
