class Question < ActiveRecord::Base
  has_many :answer_choices,
    foreign_key: :question_id,
    primary_key: :id,
    class_name: "AnswerChoice"

  belongs_to :poll,
    foreign_key: :poll_id,
    primary_key: :id,
    class_name: "Poll"

  has_many :responses,
    through: :answer_choices,
    source: :responses

  validates :text, presence: true
  validates :poll_id, presence: true

  def results
    Question.find_by_sql["
      SELECT
        ac.id,
        COUNT(*)
      FROM
        responses r
      JOIN
        answer_choices ac ON r.answer_choice_id = ac.id
      JOIN
        questions q ON ac.question_id = q.id
      WHERE
        questions.id = ?
      GROUP BY
        ac.id
    ", self.id]


    # self.answer_choices.includes(:responses).each do |choice|
    #   puts "#{choice.responses.length}"
    # end
  end
end
