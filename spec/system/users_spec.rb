require 'rails_helper'

RSpec.describe 'ユーザーログイン機能', type: :system do
  it 'ログインしていない状態でトップページにアクセスした場合、サインインページに移動する' do
    #トップページに遷移
    visit root_path
    #ログインしてない場合、サインインページに遷移している
    expect(current_path).to eq(new_user_session_path)
  end
  it 'ログイン成功、トップページに遷移' do
    #あらかじめDBに保存
    @user = FactoryBot.create(:user)
    #サインインページに遷移
    visit  new_user_session_path
    #既に保存されているユーザーのemailとpasswordを入力
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(current_path).to eq(new_user_session_path)
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    #ログインボタンをクリック
    click_on('Log in')
    #トップページに遷移している
    expect(current_path).to eq(root_path)
  end

  it 'ログイン失敗、再びサインインページに戻る' do
    #あらかじめユーザーをDBに保存
    @user = FactoryBot.create(:user)
    #トップページに遷移
    visit root_path
    #ログインしてない、サインインページに遷移
    expect(current_path).to eq(new_user_session_path)
    #誤ったユーザー情報を入力
    fill_in 'user_email', with: 'test'
    fill_in 'user_password', with: 'test'
    #ログインボタンをクリック
    click_on('Log in')
    #サインインページに戻ってきていることを確認
    expect(current_path).to eq(new_user_session_path)
  end
end
