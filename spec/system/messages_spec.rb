require 'rails_helper'

RSpec.describe 'メッセージ投稿機能', type: :system do
  before do
    #中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    @room_user = FactoryBot.create(:room_user)
  end

  context '投稿に失敗した時' do
    it '送る値が型の為、メッセージの送信に失敗する' do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      #DBに保存されていないことを確認
      expect{
        find('input[name="commit"]')
      }.not_to change { Message.count }
      #元のページに戻ってくることを確認
      expect(current_path).to eq(room_messages_path(@room_user.room))
    end
  end
  context '投稿に成功した時' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームへ遷移
      click_on(@room_user.room.name)
      #値をテキストフォームに入力
      post = 'テスト'
      fill_in 'message_content', with: post
      #送信した値がDBに保存されていることを確認
      expect{
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)
      #送信一覧画面に遷移
      expect(current_path).to eq(room_messages_path(@room_user.room))
      #送信した値がブラウザに表示されていることを確認
      expect(page).to have_content(post)
    end
    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームへ遷移
      click_on(@room_user.room.name)
      #添付された画像を定義
      image_path = Rails.root.join('public/images/test_image.png')
      #画像選択フォームの画像
      attach_file('message[image]', image_path, make_visible: true)
      #送信した値がDBに保存
      expect{
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)
      #投稿一覧に遷移
      expect(current_path).to eq(room_messages_path(@room_user.room))
      #送信した画像がブラウザに表示
      expect(page).to have_selector('img')
    end
    it 'テキスト画像の投稿に成功' do
      sign_in(@room_user.user)
      click_on(@room_user.room.name)
      image_path = Rails.root.join('public/images/test_image.png')
      #画像選択フォームに画像を添付
      attach_file('message[image]', image_path, make_visible: true)
      #値をテキストフォームに入力
      post = 'テスト'
      fill_in 'message_content', with: post
      #送信した値がDBに保存されている
      expect{
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)
      #送信した値がブラウザに表示されている
      expect(page).to have_content(post)
      #送信した画像がブラウザに表示
      expect(page).to have_selector('img')
    end
  end
end
