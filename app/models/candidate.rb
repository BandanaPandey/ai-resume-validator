# app/models/candidate.rb
class Candidate < ApplicationRecord
  has_many :job_applications
  has_many :jobs, through: :job_applications
end