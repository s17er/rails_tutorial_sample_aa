require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  before { @user = User.new(name: "Example User", email: "user@example.com",
						   password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  # 属性が含まれるかのテスト
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  # @userというsubjectが有効かどうかを確認
  # @user.valid? と等価
  it { should be_valid }
	
  # 存在性のテスト
  describe "when name is not present" do
	  before { @user.name = " " }
	  it { should_not be_valid }
  end
  describe "when email is not present" do
	  before { @user.email = " " }
	  it { should_not be_valid }
  end

  # 文字列の長さのテスト
  describe "when name is too long" do
	  before { @user.name = "a" * 51 }
	  it { should_not be_valid }
  end

  # メールアドレスフォーマットのテスト
  describe "when email format is invalid" do
	  it "should be invalid" do
		  addresses = %W[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+bax.com]
		  addresses.each do |address|
			  @user.email = address
			  expect(@user).not_to be_valid
		  end
	  end
  end
  describe "when email format is valid" do
	  it "should be valid" do
		  addresses = %W[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.com]
		  addresses.each do |address|
			  @user.email = address
			  expect(@user).to be_valid
		  end
	  end
  end

  # メールアドレスの一意性

  describe "when email address is already taken" do
	  before do
		  user_with_same_address = @user.dup
		  user_with_same_address.email = @user.email.upcase
		  user_with_same_address.save
	  end

	  it { should_not be_valid }
  end

  # パスワード関連のテスト
  describe "when password is not present" do
	  before do
		  @user = User.new(name: "Example User", email: "user@example.com",
						   password: "", password_confirmation: "") 
	  end
	  it { should_not be_valid }
  end
  describe "when password doesn't match confirmation" do
	  before { @user.password_confirmation = "mismatch" }
	  it { should_not be_valid }
  end

  # ユーザ認証のテスト
  describe "return value of authencate method" do
	  before { @user.save }
	  let(:found_user) { User.find_by(email: @user.email) }

	  describe "with valid password" do
		  it { should eq found_user.authenticate(@user.password) }
	  end
	  describe "with invalid password" do
		  let(:user_for_invalid_password) { found_user.authenticate("invallid") }
		  it { should_not eq user_for_invalid_password }
		  specify { expect(user_for_invalid_password).to be_falsy }
	  end
	  describe "with a password that's too short" do
		  before { @user.password = @user.password_confirmation = "a" * 5 }
		  it { should be_invalid }
	  end
  end


end
