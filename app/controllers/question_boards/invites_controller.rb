class QuestionBoards::InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board, only: %i(new create)
  
  def new
    @invite = Invite.new
  end

  def create
    @invite = @board.user.invites.build(invite_params)
    if @invite.save
      InviteMailer.creation_email(@invite).deliver_now
      redirect_to invites_url, notice: "回答依頼を送信しました。"
    else
      render :new
    end
  end

  private
  def set_board
    @board = current_user.question_boards.find(params[:question_board_id])
  end

  def invite_params
    params.require(:invite).permit(:name, :email, :question_board_id)
  end
end