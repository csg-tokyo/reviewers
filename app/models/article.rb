class Article < ApplicationRecord
  has_many :editors, dependent: :destroy
  has_many :users, through: :editors

  # we must give a different name to :users associated through :conflicts.
  # so we give it :conflict_users.
  has_many :conflicts, dependent: :destroy
  has_many :conflict_users, through: :conflicts, source: 'user'

  has_many :authors, dependent: :destroy
  has_many :reviewers, dependent: :destroy

  accepts_nested_attributes_for :authors, allow_destroy: true,
                                reject_if: :invalid_author
  accepts_nested_attributes_for :reviewers

  has_many :submissions, dependent: :destroy
  has_many :submissions_info, -> { select(Submission.column_names - ['file'])},
           class_name: 'Submission'

  has_many :actionlogs, dependent: :destroy

  has_many :reviews, dependent: :destroy

  def invalid_author(attributes)
    attributes['name'].blank?
  end

  def self.fetch_index
    Article.includes(:editors, :conflicts, :actionlogs,
                     :submissions_info, :reviews)
  end

  INVITED = 10
  SP_ISSUE_INVITED = 60

  TYPE = {
    '一般論文' => 20,
    '特集論文' => 30,
    '（特集）推薦論文' => 35,
    '推薦論文' => 40,
    '大会同時投稿論文' => 50,
    '（特集）依頼論文' => SP_ISSUE_INVITED,
    '依頼原稿' => INVITED,
    'その他' => 0 }


  def type_name
    TYPE.each do |k,v|
      if v == article_type
        return k
      end
    end
    article_type.to_s
  end

  SOFTWARE_PAPER = 20

  CATEGORY = {
    '研究論文' => 10,
    'ソフトウェア論文' => SOFTWARE_PAPER,
    '解説論文' => 30,
    'トピックス' => 40,
    'フォーラム' => 50,
    'その他' => 0 }

  def category_group_name
    if category == 10 || category == SOFTWARE_PAPER || category == 30
      '論文'
    else
      '記事'
    end
  end

  def category_name
    CATEGORY.each do |k,v|
      if v == category
        return k
      end
    end
    category.to_s
  end

  REVIEW_TYPE = { '記事・レター論文' => true, '通常論文' => false }

  def review_type
    REVIEW_TYPE.each do |k,v|
      if v == is_letter
        return k
      end
    end
    '？？'
  end

  def is_invited?
    article_type == Article::INVITED ||
    article_type == Article::SP_ISSUE_INVITED
  end

  def submission_date
    d = earliest_date(submissions)
    if d == nil
      self.created_at
    else
      d.created_at
    end
  end

  def camera_ready
    submissions_info.each do |s|
      if s.kind == Submission::CAMERA_READY
        return s
      end
    end
    nil
  end

  def current_status
    a1 = latest_date(submissions_info)
    a2 = latest_date(reviews)
    a3 = latest_date(actionlogs)
    a = later_date(later_date(a1, a2), a3)
    if a.nil?
      '　'
    else
      a.created_at.to_date.to_s + ' ' + a.kind_full_name
    end
  end

  def final_decision_name
    r = final_decision
    if r.nil?
      '?'
    else
      awd = if r.award then '（推薦有）' else '' end
      r.decision_name + awd
    end
  end

  def is_recommended?
    r = final_decision
    r && r.award
  end

  def final_decision
    reviews.each do |r|
      if r.is_final_report
        return r
      end
    end
    nil
  end

  def earliest_date(data)
    data.reduce(nil) do |early, d|
      if early != nil && early.created_at < d.created_at
        early
      else
        d
      end
    end
  end

  def latest_date(data)
    data.reduce(nil) do |last, d|
      if last != nil && last.created_at.beginning_of_day >
                        d.created_at.beginning_of_day
        last
      else
        d
      end
    end
  end

  # returns x if x is later than y.
  # otherwise, y if x is the same as or earlier than y.
  def later_date(x, y)
    if x.nil?
      y
    elsif y.nil?
      x
    elsif x.created_at.beginning_of_day > y.created_at.beginning_of_day
      x
    else
      y
    end
  end

  def to_json
    { :name => name, :title => title,
      :authors => authors.sort{|a,b| a.id <=> b.id }.map {|a|
        { :name => a.name, :affiliation => a.affiliation, :email => a.email }
      },
      :submission_date => submission_date.strftime('%Y/%m/%d'),
      :decision => final_decision.to_json,
      :decision_name => final_decision_name,
      :volume => volume,
      :number => number,
      :reviewers => reviewers.sort{|a,b| a.id <=> b.id }.map {|r|
        { :name => r.name, :affiliation => r.affiliation, :email => r.email }
      },
      :article_type => article_type,
      :article_type_name => type_name,
      :is_regular_paper => !is_letter,
      :article_category => category,
      :article_category_name => category_name,
      :pages => pages
    }
  end

end
