# app/models/job.rb
class Job < ApplicationRecord
  has_many :job_applications
  has_many :candidates, through: :job_applications
end