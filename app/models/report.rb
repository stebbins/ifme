zclass Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :reportee, class_name: "User"
  belongs_to :comment

  # Key for status INT in table to plaintext status of report
  enum status: { pending: 1, closed: 2 }

  # Fills in reported user when a comment is reported
  before_validation :validate_from_comment

  validates :reporter_id, presence: true
  validates :reportee_id, presence: true
  validates :note, length: { maximum: 240 }

  # Users can't report themselves
  validate :no_self_reporting

  default_scope -> { order(reportee_id: :desc).order(created_at: :desc) }

  # Returns array of User objects that have reports
  # report_status is optional :symbol argument to pull only users with
  # whatever status reports
  def self.reported_users(report_status = nil)
    query_modifier = if report_status
                       "WHERE status = #{statuses[report_status]}"
                     else
                       ""
                     end

    query = <<-SQL
      SELECT *
      FROM users
      WHERE id in (
        SELECT reportee_id FROM reports #{query_modifier} GROUP BY 1
      )
    SQL

    User.find_by_sql(query)
  end



  private

  def validate_from_comment
    unless comment.nil?
      self.reportee_id = comment.comment_by
    end
  end

  def no_self_reporting
    if reporter_id == reportee_id
      errors.add(:reportee_id, "can't report self")
    end
  end
end
