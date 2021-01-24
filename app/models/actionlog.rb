class Actionlog < ApplicationRecord
  belongs_to :article

  CONFIRM_CAMERA_READY = 180

  KIND = {
    '執筆依頼' => 10,
    '論文受領通知' => 15,
#    '論文受付・担当委員選定開始' => 20,
    '査読者選定開始' => 30,

    '査読者Ａ１回目査読依頼' => 40,
    '査読者Ｂ１回目査読依頼' => 50,

    '査読者Ｃ選定開始' => 60,
    '査読者Ｃ１回目査読依頼' => 70,

    '著者照会１回目' => 80,

    '査読者Ａ２回目査読依頼' => 90,
    '査読者Ｂ２回目査読依頼' => 100,
    '査読者Ｃ２回目査読依頼' => 110,

    '著者照会２回目' => 120,

    '査読者Ａ３回目査読依頼' => 130,
    '査読者Ｂ３回目査読依頼' => 140,
    '査読者Ｃ３回目査読依頼' => 150,

    '判定結果 編集長承認' => 160,

    '著者へ最終原稿作成依頼' => 170,

#    '最終原稿の改善確認済' => CONFIRM_CAMERA_READY,

    '編集長 判定結果を著者へ通知済' => 190,
    '著者 判定結果受領' => 195,

#    '岩波書店へ原稿送付済' => 200,

    '掲載済' => 210,

    'その他' => 0 }

  def is_camera_ready?
    kind == CONFIRM_CAMERA_READY
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
end
