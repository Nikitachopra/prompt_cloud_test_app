class HistoryController < ApplicationController
	before_action :authenticate_user!

	include ApplicationHelper

	def index
		@history = current_user.history
	end

	def new
		@history = History.new
	end

	def create
		if params[:history][:cin].length == 21
			History.create(cin_params)
			@cin = params[:history][:cin]
			@listing = @cin[0].downcase == 'l' ? true : false
			@industry = industry_type[@cin[1..2].to_i]
			@state = get_state_name(@cin[6]+@cin[7])
			@year = @cin[8..11]
			@ownership = ownership_list[@cin[12..14].to_sym]
			@registration_no = @cin[15..20]
		else
			redirect_to new_history_path, notice: "Incorrect CIN. Please try with correct CIN"
		end
	end

	private

	def cin_params
		params.require(:history).permit(:user_id,:cin)
	end
end
