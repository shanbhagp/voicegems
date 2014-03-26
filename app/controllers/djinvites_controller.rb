class DjinvitesController < ApplicationController

def index
    @invites = Djinvite.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invites }
    end
  end



end
