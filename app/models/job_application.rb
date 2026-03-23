# app/models/job_application.rb
class JobApplication < ApplicationRecord
  belongs_to :job
  belongs_to :candidate

  validates :candidate_id, uniqueness: { scope: :job_id }
end