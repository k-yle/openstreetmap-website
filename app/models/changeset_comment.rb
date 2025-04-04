# == Schema Information
#
# Table name: changeset_comments
#
#  id           :integer          not null, primary key
#  changeset_id :bigint           not null
#  author_id    :bigint           not null
#  body         :text             not null
#  created_at   :datetime         not null
#  visible      :boolean          not null
#
# Indexes
#
#  index_changeset_comments_on_author_id_and_created_at     (author_id,created_at)
#  index_changeset_comments_on_author_id_and_id             (author_id,id)
#  index_changeset_comments_on_changeset_id_and_created_at  (changeset_id,created_at)
#  index_changeset_comments_on_created_at                   (created_at)
#
# Foreign Keys
#
#  changeset_comments_author_id_fkey     (author_id => users.id)
#  changeset_comments_changeset_id_fkey  (changeset_id => changesets.id)
#

class ChangesetComment < ApplicationRecord
  belongs_to :changeset
  belongs_to :author, :class_name => "User"

  scope :visible, -> { where(:visible => true) }

  validates :id, :uniqueness => true, :presence => { :on => :update },
                 :numericality => { :on => :update, :only_integer => true }
  validates :changeset, :associated => true
  validates :author, :associated => true
  validates :visible, :inclusion => [true, false]
  validates :body, :characters => true

  # Return the comment text
  def body
    RichText.new("text", self[:body])
  end
end
