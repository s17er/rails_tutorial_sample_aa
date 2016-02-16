class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# 認証成功。ユーザをサインインさせ、ユーザーページにリダイレクトする
			sign_in user
			redirect_to user
		else
			# 認証失敗。エラーメッセージを表示し、サインインフォームを再描画する
			flash.now[:error] = 'Invalid email/password combination' # TODO 誤りあり
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
