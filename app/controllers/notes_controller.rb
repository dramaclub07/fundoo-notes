class NotesController < ApplicationController
  
  def home
  end

  def index  
    @notes = Note.all  
  end 
end
