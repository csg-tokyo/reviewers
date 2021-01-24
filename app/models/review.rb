class Review < ApplicationRecord
  belongs_to :article

  A1 = 10
  B1 = 20
  C1 = 30
  A2 = 40
  B2 = 50
  C2 = 60
  A3 = 70
  B3 = 80
  C3 = 90

  FINAL_REPORT = 200	# 編集長への報告

  KIND = {
    '査読者Ａ:１回目' => A1,
    '査読者Ｂ:１回目' => B1,
    '査読者Ｃ:１回目' => C1,

    '査読者Ａ:２回目' => A2,
    '査読者Ｂ:２回目' => B2,
    '査読者Ｃ:２回目' => C2,

    '査読者Ａ:３回目' => A3,
    '査読者Ｂ:３回目' => B3,
    '査読者Ｃ:３回目' => C3,

    '編集長への報告' => FINAL_REPORT,

    '編集長へ照会報告' => 5,

    'その他' => 0 }

  def kind_name
    KIND.each do |k,v|
      if v == kind
        return k
      end
    end
    kind.to_s + '?'
  end

  def kind_full_name
    kind_name + '/' + decision_name
  end

  def is_final_report
    kind == FINAL_REPORT
  end

  CONDITIONAL_ACCEPT = 30

  DECISION = {
    '採録' => 10,
    '採録（参考意見あり）' => 20,
    '採録（採録条件コメントあり）' => CONDITIONAL_ACCEPT,
    '照会' => 40,
    '不採録' => 50,
    '取下げ' => 60,
    'その他' => 0 }

  def decision_name
    DECISION.each do |k,v|
      if v == decision
        return k
      end
    end
    decision.to_s
  end

  def is_accepted?
    decision <= CONDITIONAL_ACCEPT
  end

  def is_conditional_accept
    decision == CONDITIONAL_ACCEPT
  end

  def to_json
    { :kind => kind, :kind_name => kind_name,
      :decision => decision, :decision_name => decision_name,
      :award => award,
      :date => created_at.strftime('%Y/%m/%d')
    }
  end

  def self.first_reviews(reviews)
    self.reviews(reviews, [A1, B1, C1])
  end

  def self.second_reviews(reviews)
    self.reviews(reviews, [A2, B2, C2])
  end

  def self.third_reviews(reviews)
    self.reviews(reviews, [A3, B3, C3])
  end

  private
  def self.reviews(reviews, kinds)
    a = nil
    b = nil
    c = nil
    reviews.each do |r|
      if r.kind == kinds[0]
        a = r
      elsif r.kind == kinds[1]
        b = r
      elsif r.kind == kinds[2]
        c = r
      end
    end
    [a, b, c]
  end
end
