class Submission < ApplicationRecord
  belongs_to :article

  validates :kind, presence: true
  validates :file, presence: true

  DATA_FILE = './files/submission-'

  CAMERA_READY = 50

  KIND = {
    '初稿' => 10, '改訂稿（１回目）' => 20,
    '改訂稿（２回目）' => 30, '改訂稿（３回目）' => 40,
    'カメラレディ稿（最終原稿）' => CAMERA_READY,
    'その他' => 0 }

  KIND2 = {
    10 => 'rev0', 20 => 'rev1', 30 => 'rev2', 40 => 'rev3',
    CAMERA_READY => 'camera',
    0 => 'unknown'
  }

  def self.fetch_only_info
    Submission.includes(:article).select(Submission.column_names - ['file'])
  end

  def is_camera_ready?
    kind == CAMERA_READY
  end

  def kind_name
    KIND.each do |k,v|
      if v == kind
        return k
      end
    end
    kind.to_s
  end

  def kind_full_name
    kind_name
  end

  def kind_short_name
    n = KIND2[kind]
    if n == nil
      kind.to_s
    else
      n
    end
  end
end
