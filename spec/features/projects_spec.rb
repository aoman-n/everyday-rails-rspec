require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  scenario "ユーザーは新しいプロジェクトを作成する" do
    user = FactoryBot.create(:user)
    sign_in user
    visit root_path

    expect{
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  # scenario "全種類の HTML 要素を扱う" do
  #   # ページを開く
  #   visit "/fake/page"
  #   # リンクまたはボタンのラベルをクリックする
  #   click_on "A link or button label"
  #   # チェックボックスのラベルをチェックする
  #   check "A checkbox label"
  #   # チェックボックスのラベルのチェックを外す
  #   uncheck "A checkbox label"
  #   # ラジオボタンのラベルを選択する
  #   choose "A radio button label"
  #   # セレクトメニューからオプションを選択する
  #   select "An option", from: "A select menu"
  #   # ファイルアップロードのラベルでファイルを添付する
  #   attach_file "A file upload label", "/some/file/in/my/test/suite.gif"

  #   # 指定した CSS に一致する要素が存在することを検証する
  #   expect(page).to have_css "h2#subheading"
  #   # 指定したセレクタに一致する要素が存在することを検証する
  #   expect(page).to have_selector "ul li"
  #   # 現在のパスが指定されたパスであることを検証する
  #   expect(page).to have_current_path "/projects/new"
  # end

  # scenario "guest adds a project" do
  #   visit projects_path
  #   save_and_open_page
  #   click_link "New Project"
  # end
end
