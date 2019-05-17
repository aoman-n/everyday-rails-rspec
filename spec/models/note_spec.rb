require 'rails_helper'

RSpec.describe Note, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  it "ユーザー、プロジェクト、メッセージがあれば有効な状態であること" do
    note = Note.new(
      message: "This is a sample note.",
      project: project,
      user: user
    )
    expect(note).to be_valid
  end

  it "メッセージがなければ無効な状態であること" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include "can't be blank"
  end

  describe "文字列に一致するメッセージを検索する" do
    let!(:note1) {
      FactoryBot.create(:note,
        message: "First Note, yeah",
        project: project,
        user: user
      )
    }
    let!(:note2) {
      FactoryBot.create(:note,
        message: "Second Note",
        project: project,
        user: user
      )
    }
    let!(:note3) {
      FactoryBot.create(:note,
        message: "Third Note, yeah",
        project: project,
        user: user
      )
    }

    context "一致するメッセージがあるとき" do
      it "検索文字列に一致するメモを返すこと" do
        expect(Note.search("yeah")).to include(note1, note3)
      end
    end

    context "一致するメッセージが1件もないとき" do
      it "空のコレクションを返すこと" do
        expect(Note.search("message")).to be_empty
      end
    end
  end

  # it "ユーザ名の取得処理をユーザーモデルに委譲すること(モックスタブ使わない)" do
  #   user = FactoryBot.create(:user, first_name: "Hiroaki", last_name: "Aoba")
  #   note = Note.new(user: user)
  #   p note.user
  #   expect(note.user_name).to eq "Hiroaki Aoba"
  # end

  # モック、スタブ使用
  it "1ユーザ名の取得処理をユーザーモデルに委譲すること" do
    user = double("user", name: "Fake User")
    note = Note.new
    # Noteモデルのnoteインスタンスのuserメソッドを実行した時
    # doubleで作ったuserが返すようにする。
    # このuserはnameしか返せない。
    # p note.user => テストダブルで作ったユーザーが取得できる
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq "Fake User"
  end

  # モック（検証機能付きのverified double）、スタブ使用
  it "2ユーザ名の取得処理をユーザーモデルに委譲すること with verified double" do
    user = instance_double("User", name: "Fake User")
    note = Note.new
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq "Fake User"
  end
end
